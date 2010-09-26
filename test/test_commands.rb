require 'test/unit'
require 'karel'

class TestCommands < Test::Unit::TestCase
  include Karel

  def test_basic_move
    WORLD <<END
BWW 
 W
 WBK

END
    assert_equal [2,3],THE_WORLD.karel
    MOVE()
    MOVE()
    assert_equal [0,3],THE_WORLD.karel
    TURNLEFT()
    TURNLEFT()
    MOVE()
    MOVE()
    assert_equal [2,3],THE_WORLD.karel
  end

  def test_explosions
WORLD <<END
KW 
 
END
    assert_move_explodes
    TURNLEFT() # K facing west bound
    assert_move_explodes
    TURNLEFT() # K facing south
    TURNLEFT() # K facing wall
    assert_move_explodes
    TURNLEFT() # K facing north bound
    TURNLEFT() # K facing west bound
    TURNLEFT() # K facing south
    MOVE()
    assert_move_explodes
    TURNLEFT()
    MOVE()
    MOVE()
    assert_move_explodes
  end

  def test_beepers
WORLD <<END
KB
  
END
    assert_equal 0,KAREL.num_beepers
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    MOVE()
    expected_string = <<END
+--+
| >|
|  |
+--+
END
    assert_equal expected_string, THE_WORLD.to_s
    PICKBEEPER()
    assert_equal 1,KAREL.num_beepers
    assert !THE_WORLD[0,1].beeper?
    expected_string = <<END
+--+
| >|
|  |
+--+
END
    assert_equal expected_string, THE_WORLD.to_s
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    MOVE()
    PUTBEEPER()
    assert_equal 0,KAREL.num_beepers
    assert THE_WORLD[1,1].beeper?
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    MOVE()
    expected_string = <<END
+--+
|  |
|<B|
+--+
END
    assert_equal expected_string, THE_WORLD.to_s
    assert_raises Explosion do
      PUTBEEPER()
    end
    assert_raises Explosion do
      PICKBEEPER()
    end
  end

  private

  def assert_move_explodes
    assert_raises Explosion do
      MOVE()
    end
  end
end

