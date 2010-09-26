require 'test/unit'
require 'karel'

class KarelTestCase < Test::Unit::TestCase
  include Karel

  def setup
    SILENT()
  end

  def test_nothing
  end
end
