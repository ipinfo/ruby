# frozen_string_literal: true
require 'test_helper'

class IpinfoIoTest < Minitest::Test
  IP4 = '195.233.174.116'
  IP6 = 'f4bc:bab1:4d39:9c0b:8797:a867:e6ce:6629'

  def test_that_it_has_a_version_number
    refute_nil ::IpinfoIo::VERSION
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
    expected = {'ip' => IP6 }

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
