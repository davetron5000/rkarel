require 'test/unit'
require 'karel'

class TestWorld < Test::Unit::TestCase
  include Karel

  def test_valid_world
    WORLD <<END
KWB

 B
END
    assert_equal 3,THE_WORLD.width
    assert_equal 3,THE_WORLD.height
    x,y = THE_WORLD.karel
    assert_equal 0,x
    assert_equal 0,y
    assert THE_WORLD[0,1].wall?
    assert THE_WORLD[0,2].beeper?
    assert THE_WORLD[2,1].beeper?
    assert_equal "KWB\n   \n B \n", THE_WORLD.to_s
    THE_WORLD.karel = [0,2]
    x,y = THE_WORLD.karel
    assert_equal 0,x
    assert_equal 2,y
    assert THE_WORLD[0,2].beeper?
    assert_raises Explosion do
      THE_WORLD.karel = [0,1]
    end
  end

end
