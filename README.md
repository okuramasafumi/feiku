# Feiku

Feiku (pronounced as "fake") is a tool to generate fake data. Unlike other solutions, it doesn't use YAML file to define data. Instead, it generates random data with specified formats like `sprintf` method.

## Why Feiku?

Existing solutions tend to be memory-consuming because it loads all data into memory soon after `require`. It works, but 99.99% of the loaded data are unused. It's a waste.

Also, while they provide tons of preset data, they don't provide a feature to enable custom data format. Think of addresses. What would be an ideal address for your country? Addresses in China should be different from ones in France. We want to define our own address format and then fill realistic value in it. With Feiku, it's possible.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add feiku

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install feiku

## Usage

```ruby
Feiku.register(:Name, format: "%{first_name} %{last_name}", value: :string, length: 3..10)
Feiku::Name.generate # => "jfsihgi ajivns"
Feiku::Name.generate # => "love ruby"

value = {
  first_name: ["Yukihiro", "David", "Sandi"],
  last_name: ["Matsumoto", "Hansson", "Metz"]
}
Feiku.register(:DeveloperName, format: "Dev: %{first_name} %{last_name}", value: value)
Feiku::DeveloperName.generate # => "Dev: David Matsumoto"
Feiku::DeveloperName.generate # => "Dev: Sandi Hansson"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okuramasafumi/feiku. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/okuramasafumi/feiku/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Feiku project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/okuramasafumi/feiku/blob/master/CODE_OF_CONDUCT.md).
