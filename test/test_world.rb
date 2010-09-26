require 'test/unit'
require 'karel'

class TestWorld < Test::Unit::TestCase
  include Karel

  def test_valid_world
    WORLD <<END
KWB 

 B
END
    assert_equal 4,THE_WORLD.width
    assert_equal 3,THE_WORLD.height
    x,y = THE_WORLD.karel
    assert_equal 0,x
    assert_equal 0,y
    assert THE_WORLD[0,1].wall?
    assert THE_WORLD[0,2].beeper?
    assert THE_WORLD[2,1].beeper?
    assert_equal "KWB \n    \n B  \n", THE_WORLD.to_s
    THE_WORLD.karel = [0,2]
    x,y = THE_WORLD.karel
    assert_equal 0,x
    assert_equal 2,y
    assert THE_WORLD[0,2].beeper?
  end

  def test_world_with_bad_character
    assert_raises InvalidWorld do
    WORLD <<END
KWB 

 BX
END
    end
  end

  def test_world_with_no_karel
    assert_raises InvalidWorld do
    WORLD <<END
 WB 

 B
END
    end
  end

  def test_changes_to_world
    WORLD <<END
BWWK
 W
 W
 BB
END
    assert THE_WORLD[0,0].beeper?
    THE_WORLD.remove_beeper(0,0)
    assert !THE_WORLD[0,0].beeper?

    assert !THE_WORLD[1,2].beeper?
    THE_WORLD.add_beeper(1,2)
    assert THE_WORLD[1,2].beeper?

    assert_raises SquareOccupied do
      THE_WORLD.add_beeper(0,1) 
    end
    assert_raises NoBeeper do
      THE_WORLD.remove_beeper(0,1) 
    end
    assert_raises SquareOccupied do
      THE_WORLD.add_beeper(3,1) 
    end
    assert_raises NoBeeper do
      THE_WORLD.remove_beeper(3,0) 
    end

    assert_raises Explosion do
      THE_WORLD.karel = [0,1]
    end
  end
end
