# Secretfile

A standard way to bring secrets into your app.

```
# Secretfile
SECRET1 not/in/vault:set_in_env
SECRET2 secret/test:value
SECRET3 not/in/vault:expected_to_raise
```

Depends on [Hashicorp Vault](https://www.vaultproject.io/). Used in production at [Faraday](https://www.faraday.io).

## Differences from `secret_garden`

The initial implementation of Secretfile in ruby was [`secret_garden`](https://github.com/erithmetic/secret_garden).

<Table>
  <tr>
    <th>What</th>
    <th><code>secret_garden</code> (other gem)</th>
    <th><code>secretfile</code> (this gem)</th>
  </tr>
  <tr>
    <td>Caches secrets in memory?</td>
    <td>Yes - an instance variable held secrets gotten from Vault, etc.</td>
    <td>No - always checks ENV and then calls out to vault.</td>
  </tr>
  <tr>
    <td>Configurable backends?</td>
    <td>Yes - you <code>require 'secret_garden/vault'</code> etc.</td>
    <td>No - you only get vault, and it's required by default</td>
  </tr>
</Table>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'secretfile'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secretfile

## Usage

In your Secretfile:

```
DATABASE_URL secrets/$VAULT_ENV/database:url
```

Then you call

```
Secretfile.get('DATABASE_URL') # looks for ENV['DATABASE_URL'], falling back to secrets/$VAULT_ENV/database:url
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/faradayio/secretfile_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Secretfile project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/faradayio/secretfile_ruby/blob/master/CODE_OF_CONDUCT.md).

## Sponsor

<p><a href="https://www.faraday.io"><img src="https://s3.amazonaws.com/faraday-assets/files/img/logo.svg" alt="Faraday logo"/></a></p>

We use `secretfile` for [B2C customer lifecycle optimization at Faraday](https://www.faraday.io).

## Copyright

Copyright 2019 Faraday
