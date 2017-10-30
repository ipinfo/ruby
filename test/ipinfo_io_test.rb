require 'test_helper'

class IpinfoIoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IpinfoIo::VERSION
  end

  def test_machine_location
    response = {
      "ip" => "49.229.162.85",
      "city" => "",
      "region" => "",
      "country" => "TH",
      "loc" => "13.7500,100.4667",
      "org" => "AS131445 ADVANCED WIRELESS NETWORK COMPANY LIMITED"
    }

  	assert_equal response, IpinfoIo.call
  end
end
