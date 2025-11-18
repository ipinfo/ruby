# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ipinfo'
require 'ipinfo_lite'
require 'ipinfo_core'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(
    Minitest::Reporters::SpecReporter.new
)
