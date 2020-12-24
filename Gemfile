# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
    gem 'bundler'
    gem 'minitest'
    gem 'minitest-reporters'
    gem 'minitest-vcr'
    gem 'rack', '>= 1.5'
    gem 'rake'
    gem 'rubocop'
    gem 'webmock'

    platforms :mri do
        # to avoid problems, bring Byebug in on just versions of Ruby under which
        # it's known to work well
        if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.0.0')
            gem 'byebug'
            gem 'pry'
            gem 'pry-byebug'
        end
    end
end
