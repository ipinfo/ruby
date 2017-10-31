# frozen_string_literal: true
require 'test_helper'

class IpinfoIoTest < Minitest::Test
  IP4 = '195.233.174.116'
  IP6 = '2601:9:7680:363:75df:f491:6f85:352f'

  def test_that_it_has_a_version_number
    refute_nil ::IpinfoIo::VERSION
  end

  def test_set_access_token
    assert IpinfoIo.access_token = 'test_token'

    VCR.use_cassette('lookup_with_token') do
      IpinfoIo.lookup
      assert_requested :get, "https://ipinfo.io?token=test_token"
    end

    IpinfoIo.access_token = "'Stop!' said Fred"

    VCR.use_cassette('lookup_with_awkward_token') do
      IpinfoIo.lookup
      assert_requested :get, "https://ipinfo.io?token=%27Stop%21%27+said+Fred"
    end
  end

  def test_rate_limit_error
    stub_request(:get, 'https://ipinfo.io').to_return(body:'', status: 429)
    error = assert_raises(IpinfoIo::RateLimitError) { IpinfoIo.lookup }
    assert_equal "To increase your limits, please review our paid plans at https://ipinfo.io/pricing", error.message
  end

  def test_lookup_without_arg
    expected = {
      "ip" => "110.171.151.183",
      "hostname" => "cm-110-171-151-183.revip7.asianet.co.th",
      "city" => "Chiang Mai",
      "region" => "Chiang Mai Province",
      "country" => "TH",
      "loc" => "18.7904,98.9847",
      "org" => "AS17552 TRUE INTERNET CO., LTD.",
      "postal" => "50000"
    }

    VCR.use_cassette('current machine search') do
      assert_equal expected, IpinfoIo.lookup
    end
  end

  def test_lookup_ip6
    expected = {
      "ip"=>"2601:9:7680:363:75df:f491:6f85:352f",
      "city"=>"",
      "region"=>"",
      "country"=>"US",
      "loc"=>"37.7510,-97.8220",
      "org"=>"AS7922 Comcast Cable Communications, LLC"
    }

    VCR.use_cassette('search with ip6') do
      assert_equal expected, IpinfoIo.lookup(IP6)
    end
  end

  def test_lookup_ip4
    expected = {
      "ip"=> IP4,
      "city"=>"",
      "region"=>"",
      "country"=>"DE",
      "loc"=>"51.2993,9.4910",
      "org"=>"AS12663 Vodafone Italia S.p.A."
    }

    VCR.use_cassette('search with random ip') do
      assert_equal expected, IpinfoIo.lookup(IP4)
    end
  end
end
