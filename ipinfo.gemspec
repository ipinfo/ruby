# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ipinfo/version'

Gem::Specification.new do |spec|
  spec.name          = "IPinfo"
  spec.version       = IPinfo::VERSION
  spec.required_ruby_version = ">= 2.0.0"
  spec.authors       = ["Stanislav K, James Timmins"]
  spec.email         = ["jameshtimmins@gmail.com"]

  spec.summary       = %q{ The official Python library for IPinfo. IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier and IP type data sets. You can visit our developer docs at https://ipinfo.io/developers. }
  spec.description   = %q{ The official Python library for IPinfo. IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier and IP type data sets. You can visit our developer docs at https://ipinfo.io/developers. }
  spec.homepage      = "https://ipinfo.io"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata['allowed_push_host'] = "http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.add_runtime_dependency 'faraday', '~> 0'
  spec.add_runtime_dependency 'lrucache', '~> 0.1.4'
  spec.add_runtime_dependency 'json', '~> 2.1'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
