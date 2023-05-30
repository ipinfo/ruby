# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/ipinfo/adapter'

require 'faraday/net_http_persistent'
require 'faraday/typhoeus'
require 'faraday/patron'
require 'faraday/httpclient'
require 'faraday/excon'

# No updates since 2021, the method `dependecy` from the class Faraday::Adapter has been removed
# https://github.com/lostisland/faraday/blob/main/UPGRADING.md#the-dependency-method-in-middlewares-has-been-removed
# require 'faraday/em_http'
# require 'faraday/em_synchrony'

class IPinfo::AdapterTest < Minitest::Test
    def test_default
        adapter = IPinfo::Adapter.new
        assert_equal(
            adapter.conn.adapter,
            Faraday::Adapter::NetHttp
        )
    end

    SUPPORTED_ADAPTERS = {
        net_http: Faraday::Adapter::NetHttp,
        net_http_persistent: Faraday::Adapter::NetHttpPersistent,
        typhoeus: Faraday::Adapter::Typhoeus,
        patron: Faraday::Adapter::Patron,
        # em_synchrony: Faraday::Adapter::EMSynchrony,
        # em_http: Faraday::Adapter::EMHttp,
        excon: Faraday::Adapter::Excon,
        httpclient: Faraday::Adapter::HTTPClient
    }.freeze

    def test_unsupported_adapter
        error = assert_raises(Faraday::Error) do
            IPinfo::Adapter.new(nil, :missing_adapter)
        end
        assert_equal(
            error.message,
            ':missing_adapter is not registered on Faraday::Adapter'
        )
    end

    def test_all_possible_adapters
        SUPPORTED_ADAPTERS.each_key do |key|
            adapter = IPinfo::Adapter.new(nil, key)
            assert_equal(
                adapter.conn.adapter,
                SUPPORTED_ADAPTERS[key]
            )
        end
    end
end
