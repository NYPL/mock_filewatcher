# MockFilewatcher

This is for non-production, internal use.
It is just a test harness used to create Ruby Hashes similar
to [the real FileWatcher](https://github.com/NYPL/Processor) used in media ingest.

## Developer Note

To experiment with code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mock_filewatcher', git: "https://github.com/NYPL/mock_filewatcher.git", tag: "some-version-number"
```

And then execute:

    $ bundle

## Usage


```ruby
require 'mock_filewatcher'
require 'json'

my_mock_file_watcher = MockFilewatcher.new

#Returns a hash
my_mock_file_watcher.create_fake_message

#Returns a valid JSON string
JSON.generate(my_mock_file_watcher.create_fake_message)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
