# frozen_string_literal: true

require 'test_helper'

class IPinfoTest < Minitest::Test
    TEST_IPV4 = '8.8.8.8'
    TEST_IPV6 = '2601:9:7680:363:75df:f491:6f85:352f'

    def test_that_it_has_a_version_number
        refute_nil ::IPinfo::VERSION
    end

    def test_set_adapter
        ipinfo = IPinfo.create(
            ENV['IPINFO_TOKEN'],
            { http_client: :excon }
        )

        assert(ipinfo.httpc = :excon)
    end

    def assert_ip6(resp)
        assert_equal(resp.ip, TEST_IPV6)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV6))
        assert_equal(resp.city, 'Mount Laurel')
        assert_equal(resp.region, 'New Jersey')
        assert_equal(resp.country, 'US')
        assert_equal(resp.country_name, 'United States')
        assert_equal(resp.loc, '39.9340,-74.8910')
        assert_equal(resp.latitude, '39.9340')
        assert_equal(resp.longitude, '-74.8910')
        assert_equal(resp.postal, '08054')
        assert_equal(resp.timezone, 'America/New_York')
        assert_equal(
            resp.asn,
            {
                "asn": 'AS7922',
                "name": 'Comcast Cable Communications, LLC',
                "domain": 'comcast.com',
                "route": '2601::/20',
                "type": 'isp'
            }
        )
        assert_equal(
            resp.company,
            {
                "name": 'Comcast Cable Communications, LLC',
                "domain": 'comcast.com',
                "type": 'isp'
            }
        )
        assert_equal(
            resp.privacy,
            {
                "vpn": false,
                "proxy": false,
                "tor": false,
                "hosting": false
            }
        )
        assert_equal(
            resp.abuse,
            {
                "address": 'US, NJ, Mount Laurel, ' \
                           '1800 Bishops Gate Blvd, 08054',
                "country": 'US',
                "email": 'abuse@comcast.net',
                "name": 'Network Abuse and Policy Observance',
                "network": '2601:9::/32',
                "phone": '+1-888-565-4329'
            }
        )
        assert_equal(
            resp.domains,
            {
                "total": 0,
                "domains": []
            }
        )
    end

    def test_lookup_ip6
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV6)
            assert_ip6(resp)
        end
    end

    def assert_ip4(resp)
        assert_equal(resp.ip, TEST_IPV4)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV4))
        assert_equal(resp.hostname, 'dns.google')
        assert_equal(resp.anycast, true)
        assert_equal(resp.city, 'Mountain View')
        assert_equal(resp.region, 'California')
        assert_equal(resp.country, 'US')
        assert_equal(resp.country_name, 'United States')
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
                "type": 'business'
            }
        )
        assert_equal(
            resp.company,
            {
                "name": 'Google LLC',
                "domain": 'google.com',
                "type": 'business'
            }
        )
        assert_equal(
            resp.privacy,
            {
                "vpn": false,
                "proxy": false,
                "tor": false,
                "hosting": false
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

    def test_lookup_ip4
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.details(TEST_IPV4)
            assert_ip4(resp)
        end
    end
end
