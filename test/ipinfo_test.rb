# frozen_string_literal: true

require_relative './test_helper'

class IPinfoTest < Minitest::Test
    TEST_IPV4 = '8.8.8.8'
    TEST_IPV6 = '2001:240:2a54:3900::'
    TEST_RESPROXY_IP = '175.107.211.204'

    def assert_ip6(resp)
        assert_equal(resp.ip, TEST_IPV6)
        assert_equal(resp.ip_address, IPAddr.new(TEST_IPV6))
        refute_nil(resp.city)
        refute_nil(resp.region)
        assert_equal(resp.country, 'JP')
        assert_equal(resp.country_name, 'Japan')
        assert_equal(resp.is_eu, false)
        refute_nil(resp.loc)
        refute_nil(resp.latitude)
        refute_nil(resp.longitude)
        refute_nil(resp.postal)
        assert_equal(resp.timezone, 'Asia/Tokyo')
        assert_equal(resp.country_flag_url, 'https://cdn.ipinfo.io/static/images/countries-flags/JP.svg')
        refute_nil(resp.asn)
        assert_equal(resp.asn[:asn], 'AS2497')
        assert_equal(resp.asn[:name], 'Internet Initiative Japan Inc.')
        refute_nil(resp.asn[:domain])
        assert_equal(resp.asn[:route], '2001:240::/32')
        assert_equal(resp.asn[:type], 'isp')
        refute_nil(resp.company)
        refute_nil(resp.company[:name])
        refute_nil(resp.company[:domain])
        assert_equal(resp.company[:type], "isp")
        assert_equal(
            resp.privacy,
            {
                vpn: false,
                proxy: false,
                tor: false,
                relay: false,
                hosting: false,
                service: ''
            }
        )
        assert_equal(
            resp.abuse,
            {
                address: 'Brisbane, Australia',
                country: 'AU',
                email: 'helpdesk@apnic.net',
                name: 'ABUSE APNICAP',
                network: '2001:200::/23',
                phone: '+000000000'
            }
        )
        assert_equal(
            resp.domains,
            {
                page: 0,
                total: 0,
                domains: []
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
        refute_nil(resp.loc)
        refute_nil(resp.latitude)
        refute_nil(resp.longitude)
        assert_equal(resp.postal, '94043')
        assert_equal(resp.timezone, 'America/Los_Angeles')
        assert_equal(
            resp.asn,
            {
                asn: 'AS15169',
                name: 'Google LLC',
                domain: 'google.com',
                route: '8.8.8.0/24',
                type: 'hosting'
            }
        )
        assert_equal(
            resp.company,
            {
                name: 'Google LLC',
                domain: 'google.com',
                type: 'hosting',
                firmographic: {
                    name: 'Google LLC',
                    domain: 'google.com',
                    founded: '2002-10-22',
                    employees: nil,
                    sic: 5734
                }
            }
        )
        assert_equal(
            resp.privacy,
            {
                vpn: false,
                proxy: false,
                tor: false,
                relay: false,
                hosting: true,
                service: ''
            }
        )
        assert_equal(
            resp.abuse,
            {
                address: 'US, CA, Mountain View, ' \
                         '1600 Amphitheatre Parkway, 94043',
                country: 'US',
                email: 'network-abuse@google.com',
                name: 'Abuse',
                network: '8.8.8.0/24',
                phone: '+1-650-253-0000'
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

    def test_resproxy
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        # multiple checks for cache
        (0...5).each do |_|
            resp = ipinfo.resproxy(TEST_RESPROXY_IP)
            assert_equal(resp.ip, TEST_RESPROXY_IP)
            refute_nil(resp.last_seen)
            refute_nil(resp.percent_days_seen)
            refute_nil(resp.service)
        end
    end

    def test_resproxy_empty
        ipinfo = IPinfo.create(ENV['IPINFO_TOKEN'])

        resp = ipinfo.resproxy(TEST_IPV4)
        assert_equal(resp.all, {})
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
