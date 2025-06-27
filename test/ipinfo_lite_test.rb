# frozen_string_literal: true

require_relative 'test_helper'

class IPinfoLiteTest < Minitest::Test
    TEST_IPV4 = '8.8.8.8'
    TEST_IPV6 = '2001:240:2a54:3900::'

    def assert_ip6(resp)
        assert_equal(resp.ip, TEST_IPV6)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV6))
        assert_equal(resp.country, 'Japan')
        assert_equal(resp.country_code, 'JP')
        assert_equal(resp.country_name, 'Japan')
        assert_equal(resp.is_eu, false)
        assert_equal(resp.country_flag['emoji'], '🇯🇵')
        assert_equal(resp.country_flag['unicode'], 'U+1F1EF U+1F1F5')
        assert_equal(resp.country_flag_url, 'https://cdn.ipinfo.io/static/images/countries-flags/JP.svg')
        assert_equal(resp.country_currency['code'], 'JPY')
        assert_equal(resp.country_currency['symbol'], '¥')
        assert_equal(resp.continent['code'], 'AS')
        assert_equal(resp.continent['name'], 'Asia')
        assert_equal(resp.asn, 'AS2497')
    end

    def assert_ip4(resp)
        assert_equal(resp.ip, TEST_IPV4)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV4))
        assert_equal(resp.country, 'United States')
        assert_equal(resp.country_code, 'US')
        assert_equal(resp.country_name, 'United States')
        assert_equal(resp.is_eu, false)
        assert_equal(resp.country_flag['emoji'], '🇺🇸')
        assert_equal(resp.country_flag['unicode'], 'U+1F1FA U+1F1F8')
        assert_equal(resp.country_flag_url, 'https://cdn.ipinfo.io/static/images/countries-flags/US.svg')
        assert_equal(resp.country_currency['code'], 'USD')
        assert_equal(resp.country_currency['symbol'], '$')
        assert_equal(resp.continent['code'], 'NA')
        assert_equal(resp.continent['name'], 'North America')
        assert_equal(resp.asn,'AS15169')
    end

    def test_that_it_has_a_version_number
        refute_nil ::IPinfo::VERSION
    end

    def test_set_adapter_v4
        ipinfo = IPinfoLite.create(
            ENV.fetch('IPINFO_TOKEN', nil),
            { http_client: :excon }
        )

        assert(ipinfo.httpc = :excon)
    end

    def test_lookup_ip6
        ipinfo = IPinfoLite.create(ENV.fetch('IPINFO_TOKEN', nil))

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV6)
            assert_ip6(resp)
        end
    end

    def test_lookup_ip4
        ipinfo = IPinfoLite.create(ENV.fetch('IPINFO_TOKEN', nil))

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV4)
            assert_ip4(resp)
        end
    end
end
