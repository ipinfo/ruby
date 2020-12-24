source 'https://rubygems.org'

gemspec

group :development do
  gem "rack", ">= 1.5"
  gem "bundler"
  gem "rake"
  gem "minitest"
  gem 'minitest-vcr'
  gem 'minitest-reporters'
  gem 'webmock'
  gem 'rubocop'

  platforms :mri do
    # to avoid problems, bring Byebug in on just versions of Ruby under which
    # it's known to work well
    if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new("2.0.0")
      gem "byebug"
      gem "pry"
      gem "pry-byebug"
    end
  end
end
