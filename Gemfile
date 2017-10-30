source 'https://rubygems.org'

# Specify your gem's dependencies in ipinfo_io.gemspec
gemspec


group :development do
  if RUBY_VERSION >= "2.2.2"
    gem "rack", ">= 1.5"
  else
    gem "rack", ">= 1.5", "< 2.0" # rubocop:disable Bundler/DuplicatedGem
  end

  gem "bundler"
  gem "rake"
  gem "minitest"
end