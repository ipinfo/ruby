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

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
    # 'allowed_push_host' to allow pushing to a single host or delete this
    # section to allow pushing to any host.
    if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "http://mygemserver.com'"
    else
        raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
    end

    spec.add_runtime_dependency 'faraday', '~> 1.0'
    spec.add_runtime_dependency 'json', '~> 2.1'
    spec.add_runtime_dependency 'lru_redux', '~> 1.1'

    spec.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']
end
