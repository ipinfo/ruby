$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ipinfo_io'

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest-vcr'
require 'webmock/minitest'

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new
)


VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

MinitestVcr::Spec.configure!
