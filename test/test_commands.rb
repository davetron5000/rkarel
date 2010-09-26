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
end
