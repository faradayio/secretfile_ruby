require 'secretfile/version'

require 'singleton'
require 'vault'

class Secretfile
  include Singleton

  class << self
    def get(k)
      instance.get k
    end

    def group
      begin
        instance.mutex.synchronize do
          raise "Can't nest Secretfile.group" if instance.group
          instance.group = {}
        end
        yield
      ensure
        instance.group = nil
      end
    end
  end

  attr_reader :spec
  attr_reader :mutex
  attr_accessor :group

  def initialize
    super # singleton magic i guess
    @mutex = Mutex.new
    read_spec
  end

  def get(k)
    k = k&.to_s
    unless spec.has_key?(k)
      raise "Secret #{k.inspect} not found in Secretfile, expected one of #{spec.keys.join('/')}"
    end
    if ENV.has_key?(k)
      ENV[k]
    else
      path, field = spec.fetch k
      payload = if group&.has_key?(path)
        group[path]
      else
        memo = Vault.logical.read(path) or raise("Secret #{k.inspect} not found in Vault at #{path}")
        group[path] = memo if group
        memo
      end
      payload.data[field.to_sym] or raise("Secret #{k.inspect} not found in Vault at #{path}:#{field}")
    end
  end

  private

  def spec_path
    ENV.fetch('SECRETFILE_PATH', 'Secretfile')
  end

  VALID_LINE = /\A\w+\s+[\w\-\/]+:\w+\z/
  def read_spec
    @spec = IO.readlines(spec_path).inject({}) do |memo, line|
      line.chomp!
      next memo if line =~ /\A\s*\z/
      next memo if line =~ /\A\s*#/
      line.gsub!(/\$(\{)?([A-Z0-9_]+)(\})?/) do
        if $1 == '{' and $3 != '}'
          raise "Unmatched brackets in #{line.inspect}"
        end
        ENV.fetch $2
      end
      raise "Expected KKKK vvvv:vvv, got #{line.inspect}" unless line =~ VALID_LINE
      k, v = line.split /\s+/, 2
      memo[k] = v.split ':', 2
      memo
    end
  end
end

Secretfile.instance
