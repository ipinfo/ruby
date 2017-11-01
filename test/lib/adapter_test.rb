# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ipinfo_io/adapter'

class IpinfoIo::AdapterTest < Minitest::Test
  def test_default
    adapter = IpinfoIo::Adapter.new
    assert(adapter.conn.builder.handlers[0] === Faraday::Adapter::NetHttp)
  end

  SUPPORTED_ADAPTERS = {
    net_http: Faraday::Adapter::NetHttp,
    net_http_persistent: Faraday::Adapter::NetHttpPersistent,
    typhoeus: Faraday::Adapter::Typhoeus,
    patron: Faraday::Adapter::Patron,
    em_synchrony: Faraday::Adapter::EMSynchrony,
    em_http: Faraday::Adapter::EMHttp,
    excon: Faraday::Adapter::Excon,
    httpclient: Faraday::Adapter::HTTPClient
  }

  def test_unsupported_adapter
    error = assert_raises(Faraday::Error) { IpinfoIo::Adapter.new(nil, :missing_adapter) }
    assert_equal error.message, ":missing_adapter is not registered on Faraday::Adapter"
  end

  def test_all_possible_adapters
    SUPPORTED_ADAPTERS.keys.each do |key|
      adapter = IpinfoIo::Adapter.new(nil, key)
      assert(adapter.conn.builder.handlers[0] === SUPPORTED_ADAPTERS[key])
    end
  end
end
