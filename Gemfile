source 'https://rubygems.org'

# Specify your gem's dependencies in ipinfo_io.gemspec
gemspec


group :development do
  # Rack 2.0+ requires Ruby >= 2.2.2 which is problematic for the test suite on
  # older Ruby versions. Check Ruby the version here and put a maximum
  # constraint on Rack if necessary.

  if RUBY_VERSION >= "2.2.2"
    gem "rack", ">= 1.5"
  else
    gem "rack", ">= 1.5", "< 2.0"
  end

  gem "bundler"
  gem "rake"
  gem "minitest"
end
