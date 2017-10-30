[![Build Status](https://travis-ci.org/ipinfoio/ruby.svg?branch=master)](https://travis-ci.org/ipinfoio/ruby)

# Ipinfo.io

Use the ipinfo.io IP lookup API wrapper to quickly and simply integrate IP geolocation. Save yourself the hassle of setting up local GeoIP libraries and having to remember to regularly update the data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ipinfo_io'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ipinfo_io

## Usage

Most obvious way to use this script:

```
IpinfoIo::lookup(ip)
```

You can also include it:

```
class YourClass
  include IpinfoIo

  def some_method
    lookup(ip)
  end
end
```

API has a rate limit of 1,000 API requests per day. If you do more then that, then expect `IpinfoIo::RateLimitError` to appear.

### Requirements
- Ruby 2.0+

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Setting up project:
- Be sure to have **rvm** or **rbenv**
- Be sure to have **bundler gem** installed.
- `bundle install`
- Check that your IDE/editor can handle [.editorconfig](http://editorconfig.org) file

Running tests is as easy as `bundle exec rake`

Bug reports and pull requests are welcome on GitHub at https://github.com/ipinfoio/ruby/.

