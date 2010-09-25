require 'test/unit'
require 'karel'

class TestWorld < Test::Unit::TestCase
  include Karel

  def test_valid_world
    WORLD.IS <<END
KWB

 B
END
    assert_equal 3,WORLD.width
    assert_equal 3,WORLD.height
    x,y = WORLD.karel
    assert_equal 0,x
    assert_equal 0,y
    assert WORLD[0,1].wall?
    assert WORLD[0,2].beeper?
    assert WORLD[2,1].beeper?
    assert_equal "KWB\n   \n B \n", WORLD.to_s
    WORLD.karel = [0,2]
    x,y = WORLD.karel
    assert_equal 0,x
    assert_equal 2,y
    assert WORLD[0,2].beeper?
    assert_raises Explosion do
      WORLD.karel = [0,1]
    end
  end

end
