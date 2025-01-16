# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ipinfo/version'

Gem::Specification.new do |spec|
    spec.name = 'IPinfo'
    spec.version = IPinfo::VERSION
    spec.required_ruby_version = '>= 2.5.0'
    spec.authors       = ['Stanislav K, James Timmins', 'Uman Shahzad']
    spec.email         = ['jameshtimmins@gmail.com', 'uman@mslm.io']

    spec.summary       = ' This is a ruby wrapper for http://ipinfo.io. '
    spec.description   = ' This is a ruby wrapper for http://ipinfo.io. '
    spec.homepage      = 'https://ipinfo.io'

    spec.add_runtime_dependency 'faraday', '~> 2.0'
    # add development dependency to test against faraday adapters that are been moved out the gem
    spec.add_development_dependency 'async-http-faraday'
    spec.add_development_dependency 'faraday-net_http_persistent', '~> 2.0'
    spec.add_development_dependency 'faraday-typhoeus', '~> 1.0'
    spec.add_development_dependency 'faraday-patron', '~> 2.0'
    spec.add_development_dependency 'faraday-httpclient', '~> 2.0'
    spec.add_development_dependency 'faraday-excon', '~> 2.1'

    spec.add_runtime_dependency 'json', '~> 2.1'
    spec.add_runtime_dependency 'sin_lru_redux'

    spec.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']
end
