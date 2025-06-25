# frozen_string_literal: true

require_relative './test_helper'

class IPinfoTest < Minitest::Test
    TEST_IPV4 = '8.8.8.8'
    TEST_IPV6 = '2001:240:2a54:3900::'

    def assert_ip6(resp)
        assert_equal(resp.ip, TEST_IPV6)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV6))
        assert_equal(resp.city, 'Osaka')
        assert_equal(resp.region, 'Osaka')
        assert_equal(resp.country, 'JP')
        assert_equal(resp.country_name, 'Japan')
        assert_equal(resp.is_eu, false)
        assert_equal(resp.loc, '34.6938,135.5011')
        assert_equal(resp.latitude, '34.6938')
        assert_equal(resp.longitude, '135.5011')
        assert_equal(resp.postal, '543-0062')
        assert_equal(resp.timezone, 'Asia/Tokyo')
        assert_equal(resp.country_flag_url, 'https://cdn.ipinfo.io/static/images/countries-flags/JP.svg')
        assert_equal(
            resp.asn,
            {
                "asn": 'AS2497',
                "name": 'Internet Initiative Japan Inc.',
                "domain": 'iij.ad.jp',
                "route": '2001:240::/32',
                "type": 'isp'
            }
        )
        assert_equal(
            resp.company,
            {
                "name": 'IIJ Internet',
                "domain": 'iij.ad.jp',
                "type": 'isp'
            }
        )
        assert_equal(
            resp.privacy,
            {
                "vpn": false,
                "proxy": false,
                "tor": false,
                "relay": false,
                "hosting": false,
                "service": ''
            }
        )
        assert_equal(
            resp.abuse,
            {
                "address": 'Brisbane, Australia',
                "country": 'AU',
                "email": 'helpdesk@apnic.net',
                "name": 'ABUSE APNICAP',
                "network": '2001:200::/23',
                "phone": '+000000000'
            }
        )
        assert_equal(
            resp.domains,
            {
                "page": 0,
                "total": 0,
                "domains": []
            }
        )
    end

    def assert_ip4(resp)
        assert_equal(resp.ip, TEST_IPV4)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV4))
        assert_equal(resp.hostname, 'dns.google')
        assert_equal(resp.is_anycast, true)
        assert_equal(resp.city, 'Mountain View')
        assert_equal(resp.region, 'California')
        assert_equal(resp.country, 'US')
        assert_equal(resp.country_name, 'United States')
        assert_equal(resp.is_eu, false)
        assert_equal(resp.country_flag['emoji'], '🇺🇸')
        assert_equal(resp.country_flag['unicode'], 'U+1F1FA U+1F1F8')
        assert_equal(resp.country_flag_url, 'https://cdn.ipinfo.io/static/images/countries-flags/US.svg')
        assert_equal(resp.country_currency['code'], 'USD')
        assert_equal(resp.country_currency['symbol'], '$')
        assert_equal(resp.continent['code'], 'NA')
        assert_equal(resp.continent['name'], 'North America')
        assert_equal(resp.loc, '37.4056,-122.0775')
        assert_equal(resp.latitude, '37.4056')
        assert_equal(resp.longitude, '-122.0775')
        assert_equal(resp.postal, '94043')
        assert_equal(resp.timezone, 'America/Los_Angeles')
        assert_equal(
            resp.asn,
            {
                "asn": 'AS15169',
                "name": 'Google LLC',
                "domain": 'google.com',
                "route": '8.8.8.0/24',
                "type": 'hosting'
            }
        )
        assert_equal(
            resp.company,
            {
                "name": 'Google LLC',
                "domain": 'google.com',
                "type": 'hosting'
            }
        )
        assert_equal(
            resp.privacy,
            {
                "vpn": false,
                "proxy": false,
                "tor": false,
                "relay": false,
                "hosting": true,
                "service": ''
            }
        )
        assert_equal(
            resp.abuse,
            {
                "address": 'US, CA, Mountain View, ' \
                           '1600 Amphitheatre Parkway, 94043',
                "country": 'US',
                "email": 'network-abuse@google.com',
                "name": 'Abuse',
                "network": '8.8.8.0/24',
                "phone": '+1-650-253-0000'
            }
        )
        assert_equal(resp.domains[:ip], TEST_IPV4)
        refute_nil(resp.domains[:total])
        refute_nil(resp.domains[:domains])
    end

    def test_that_it_has_a_version_number
        refute_nil ::IPinfo::VERSION
    end

    def test_set_adapter_v4
        ipinfo = IPinfo.create(
            ENV['IPINFO_TOKEN'],
            { http_client: :excon }
        )

        assert(ipinfo.httpc = :excon)
    end

    def test_lookup_ip6
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV6)
            assert_ip6(resp)
        end
    end

    # # Requires IPv6 support
    # def test_lookup_ip6_on_host_v6
    #     ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

    #     # multiple checks for cache
    #     (0...5).each do |_|
    #         resp = ipinfo.details_v6(TEST_IPV6)
    #         assert_ip6(resp)
    #     end
    # end

    def test_lookup_ip4
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV4)
            assert_ip4(resp)
        end
    end

    # # Requires IPv6 support
    # def test_lookup_ip4_on_host_v6
    #     ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

    #     # multiple checks for cache
    #     (0...5).each do |_|
    #         resp = ipinfo.details_v6(TEST_IPV4)
    #         assert_ip4(resp)
    #     end
    # end
end
