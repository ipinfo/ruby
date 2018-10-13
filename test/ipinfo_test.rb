# frozen_string_literal: true
require 'test_helper'

class IPinfoTest < Minitest::Test
  IP4 = '195.233.174.116'
  IP6 = '2601:9:7680:363:75df:f491:6f85:352f'

  def test_that_it_has_a_version_number
    refute_nil ::IPinfo::VERSION
  end

  def test_set_adapter
    ipinfo = IPinfo::getHandler(nil, {:http_client => :excon})
    assert  ipinfo.http_client = :excon
    ipinfo.http_client = nil
  end

  def test_set_access_token
    ipinfo = IPinfo::getHandler('test_token')

    VCR.use_cassette('lookup_with_token') do
      ipinfo.getDetails()
      assert_requested :get, "https://ipinfo.io?token=test_token"

    end

    ipinfo.access_token = nil
  end

  def test_rate_limit_error
    ipinfo = IPinfo::getHandler()
    stub_request(:get, 'https://ipinfo.io').to_return(body:'', status: 429)
    error = assert_raises(IPinfo::RateLimitError) { ipinfo.getDetails }
    assert_equal "To increase your limits, please review our paid plans at https://ipinfo.io/pricing", error.message
  end

  def test_lookup_without_arg
    expected = {
      ip: "110.171.151.183",
      ip_address: IPAddr.new("110.171.151.183"),
      hostname: "cm-110-171-151-183.revip7.asianet.co.th",
      city: "Chiang Mai",
      region: "Chiang Mai Province",
      country: "TH",
      country_name: "Thailand",
      loc: "18.7904,98.9847",
      latitude: "18.7904",
      longitude: "98.9847",
      org: "AS17552 TRUE INTERNET CO., LTD.",
      postal: "50000"
    }

    VCR.use_cassette('current machine search') do
      ipinfo = IPinfo::getHandler()
      response = ipinfo.getDetails()
      assert_instance_of IPinfo::Response, response
      assert_equal expected[:ip], response.ip
      assert_instance_of IPAddr, response.ip_address
      assert_equal expected[:country_name], response.country_name
      assert_equal expected, response.all

    end
  end

  def test_lookup_ip6
    expected = {
      ip: IP6,
      ip_address: IPAddr.new(IP6),
      city: "",
      region: "",
      country: "US",
      country_name: "United States",
      loc: "37.7510,-97.8220",
      latitude: "37.7510",
      longitude: "-97.8220",
      org: "AS7922 Comcast Cable Communications, LLC"
    }

    VCR.use_cassette('search with ip6') do
      ipinfo = IPinfo::getHandler()
      response = ipinfo.getDetails(IP6)
      assert_equal expected, response.all
    end
  end

  def test_lookup_ip4
    expected = {
      ip: IP4,
      ip_address: IPAddr.new(IP4),
      city: "",
      region: "",
      country: "DE",
      country_name: "Germany",
      loc: "51.2993,9.4910",
      latitude: "51.2993",
      longitude: "9.4910",
      org: "AS12663 Vodafone Italia S.p.A."
    }

    VCR.use_cassette('search with random ip') do
      ipinfo = IPinfo::getHandler()
      response = ipinfo.getDetails(IP4)
      assert_equal expected, response.all
    end
  end
end
