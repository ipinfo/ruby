# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ipinfo'
require 'ipinfo_lite'
require 'ipinfo_core'
require 'ipinfo_plus'

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

# Allow real network connections by default, but tests can disable this
WebMock.allow_net_connect!

Minitest::Reporters.use!(
    Minitest::Reporters::SpecReporter.new
)
