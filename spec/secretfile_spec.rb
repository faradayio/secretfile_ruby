RSpec.describe Secretfile do
  it "gets secret from ENV if available" do
    ENV['SECRET1'] = 'FROM_ENV'
    expect(Secretfile.get('SECRET1')).to eq('FROM_ENV')
  end

  # you need a local vault server with a secret mapped here to pass this test
  it "gets secret from vault if not in ENV" do
    expect(Secretfile.get('SECRET2')).to eq('It worked!')
  end

  it "raises if you ask it for a secret it doesn't have" do
    expect{Secretfile.get('GIBBERISH')}.to raise_error(/secret.*not found/i)
  end

  it "raises if vault is missing a secret" do
    expect{Secretfile.get('SECRET3')}.to raise_error(/secret.*not found.*in vault/i)
  end

  it "can read alternate Secretfile paths" do
    begin
      ENV['SECRETFILE_PATH'] = 'spec/other_secretfile'
      Secretfile.instance.send(:read_spec)
      expect(Secretfile.get('OTHER_SECRET')).to eq('It worked!')
    ensure
      ENV.delete 'SECRETFILE_PATH'
      Secretfile.instance.send(:read_spec)
    end
  end
end
