require 'test_helper'

class IpinfoIoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IpinfoIo::VERSION
  end

  def test_machine_location
  	assert_equal ({country: "Thailand"}), IpinfoIo.call
  end
end
