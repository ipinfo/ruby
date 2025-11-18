# frozen_string_literal: true

require_relative 'test_helper'

class IPinfoCoreTest < Minitest::Test
    TEST_IPV4 = '8.8.8.8'
    TEST_IPV6 = '2001:4860:4860::8888'

    def test_set_adapter
        ipinfo = IPinfoCore.create(
            ENV.fetch('IPINFO_TOKEN', nil),
            { 'http_client' => :excon }
        )

        assert(ipinfo.httpc = :excon)
    end

    def test_lookup_ip4
        ipinfo = IPinfoCore.create(ENV.fetch('IPINFO_TOKEN', nil))

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV4)

            # Basic fields
            assert_equal(resp.ip, TEST_IPV4)
            assert_equal(resp.ip_address, IPAddr.new(TEST_IPV4))
            assert_equal(resp.hostname, 'dns.google')

            # Geo object assertions
            assert(resp.geo.is_a?(Hash))
            refute_nil(resp.geo[:city])
            refute_nil(resp.geo[:region])
            refute_nil(resp.geo[:region_code])
            assert_equal(resp.geo[:country_code], 'US')
            assert_equal(resp.geo[:country], 'United States')
            assert_equal(resp.geo[:country_name], 'United States')
            assert_equal(resp.geo[:is_eu], false)
            refute_nil(resp.geo[:continent])
            refute_nil(resp.geo[:continent_code])
            refute_nil(resp.geo[:latitude])
            refute_nil(resp.geo[:longitude])
            refute_nil(resp.geo[:timezone])
            refute_nil(resp.geo[:postal_code])
            assert_equal(resp.geo[:country_flag]['emoji'], '🇺🇸')
            assert_equal(resp.geo[:country_flag]['unicode'], 'U+1F1FA U+1F1F8')
            assert_equal(resp.geo[:country_flag_url], 'https://cdn.ipinfo.io/static/images/countries-flags/US.svg')
            assert_equal(resp.geo[:country_currency]['code'], 'USD')
            assert_equal(resp.geo[:country_currency]['symbol'], '$')
            assert_equal(resp.geo[:continent]['code'], 'NA')
            assert_equal(resp.geo[:continent]['name'], 'North America')

            # AS object assertions
            assert(resp.as.is_a?(Hash))
            assert_equal(resp.as[:asn], 'AS15169')
            assert(resp.as[:name].is_a?(String))
            assert(resp.as[:domain].is_a?(String))
            assert(resp.as[:type].is_a?(String))

            # Network flags
            assert_equal(resp.is_anonymous, false)
            assert_equal(resp.is_anycast, true)
            assert_equal(resp.is_hosting, true)
            assert_equal(resp.is_mobile, false)
            assert_equal(resp.is_satellite, false)
        end
    end

    def test_lookup_ip6
        ipinfo = IPinfoCore.create(ENV.fetch('IPINFO_TOKEN', nil))

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV6)

            # Basic fields
            assert_equal(resp.ip, TEST_IPV6)
            assert_equal(resp.ip_address, IPAddr.new(TEST_IPV6))

            # Geo object assertions
            assert(resp.geo.is_a?(Hash))
            refute_nil(resp.geo[:city])
            refute_nil(resp.geo[:region])
            refute_nil(resp.geo[:region_code])
            assert_equal(resp.geo[:country_code], 'US')
            assert_equal(resp.geo[:country], 'United States')
            assert_equal(resp.geo[:country_name], 'United States')
            assert_equal(resp.geo[:is_eu], false)
            refute_nil(resp.geo[:continent])
            refute_nil(resp.geo[:continent_code])
            refute_nil(resp.geo[:latitude])
            refute_nil(resp.geo[:longitude])
            refute_nil(resp.geo[:timezone])
            refute_nil(resp.geo[:postal_code])
            assert_equal(resp.geo[:country_flag]['emoji'], '🇺🇸')
            assert_equal(resp.geo[:country_flag]['unicode'], 'U+1F1FA U+1F1F8')
            assert_equal(resp.geo[:country_flag_url], 'https://cdn.ipinfo.io/static/images/countries-flags/US.svg')
            assert_equal(resp.geo[:country_currency]['code'], 'USD')
            assert_equal(resp.geo[:country_currency]['symbol'], '$')
            assert_equal(resp.geo[:continent]['code'], 'NA')
            assert_equal(resp.geo[:continent]['name'], 'North America')

            # AS object assertions
            assert(resp.as.is_a?(Hash))
            assert_equal(resp.as[:asn], 'AS15169')
            assert(resp.as[:name].is_a?(String))
            assert(resp.as[:domain].is_a?(String))
            assert(resp.as[:type].is_a?(String))

            # Network flags
            assert_equal(resp.is_anonymous, false)
            assert_equal(resp.is_anycast, true)
            assert_equal(resp.is_hosting, true)
            assert_equal(resp.is_mobile, false)
            assert_equal(resp.is_satellite, false)
        end
    end

    def test_bogon_ip
        ipinfo = IPinfoCore.create(ENV.fetch('IPINFO_TOKEN', nil))

        resp = ipinfo.details('192.168.1.1')
        assert_equal(resp.bogon, true)
        assert_equal(resp.ip, '192.168.1.1')
    end
end
