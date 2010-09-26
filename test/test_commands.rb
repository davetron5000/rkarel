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

  private

  def assert_move_explodes
    assert_raises Explosion do
      MOVE()
    end
  end
end

