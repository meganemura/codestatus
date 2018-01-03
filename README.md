# Codestatus

## Installation

```ruby
gem 'codestatus'
```

## Usage

```console
# Requires public_repo scope
$ export CODESTATUS_GITHUB_TOKEN=XXXXXXXXXXXXXXX
```

```console
$ codestatus status rubygems/octokit
success
$ codestatus status npm/react
success
$ codestatus status --registry=npm react
success
$ codestatus status npm/@atlassian/aui
success
```

```ruby
puts Codestatus.status(registry: 'rubygems', package: 'octokit').status  # => success
puts Codestatus.status(registry: 'npm', package: 'react').status         # => success
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meganemura/codestatus.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
