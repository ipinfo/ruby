require 'test_helper'

class IpinfoIoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IpinfoIo::VERSION
  end
end
