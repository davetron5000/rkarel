require 'test/unit'
require 'karel'

class TestControlFlow < Test::Unit::TestCase
  include Karel

  def test_iterate
    WORLD <<END
  K 
 
 
END
    ITERATE(3.TIMES) {
      TURNLEFT()
    }
    MOVE()
    assert_equal [0,3],THE_WORLD.karel
    TURNLEFT()
    TURNLEFT()
    MOVE()
    ITERATE(2.TIMES) {
      TURNLEFT()
      MOVE()
    }
    assert_equal [1,3],THE_WORLD.karel
  end

  def test_front_clear
    WORLD <<END
W 

K
END
    assert_IF_executed(front_clear)
    assert_IF_not_executed(front_not_clear)
    MOVE()
    assert_IF_not_executed(front_clear)
    assert_IF_executed(front_not_clear)
  end

  def test_left_clear
    WORLD <<END
W K

 
END
    assert_IF_executed(left_clear)
    assert_IF_not_executed(left_not_clear)
    TURNLEFT()
    MOVE()
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    assert_IF_not_executed(left_clear)
    assert_IF_executed(left_not_clear)
  end

  def test_right_clear
    WORLD <<END
K W 

  
END
    assert_IF_executed(right_clear)
    assert_IF_not_executed(right_not_clear)
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    MOVE()
    TURNLEFT()
    assert_IF_not_executed(right_clear)
    assert_IF_executed(right_not_clear)
  end
  
  def test_on_beeper
    WORLD <<END
 B 
 K
  
END
    MOVE()
    assert_IF_executed(on_beeper)
    assert_IF_not_executed(not_on_beeper)
    PICKBEEPER()
    assert !THE_WORLD[0,1].beeper?
    assert_equal 1,KAREL.num_beepers
    TURNLEFT()
    TURNLEFT()
    MOVE()
    assert_IF_not_executed(on_beeper)
    assert_IF_executed(not_on_beeper)
  end

  def test_facing
    WORLD <<END
K
  
END
    assert_facing(:north)
    TURNLEFT()
    assert_facing(:west)
    TURNLEFT()
    assert_facing(:south)
    TURNLEFT()
    assert_facing(:east)
    TURNLEFT()
    assert_facing(:north)
  end

  def test_lonely_ELSE
    assert_raises RuntimeError do
      ELSE {
        # this shouldn't happen
      }
    end
  end

  def assert_facing(direction)
    assert_IF_executed(("facing_" + direction.to_s).to_sym)
    assert_IF_not_executed(("not_facing_" + direction.to_s).to_sym)
    Karel::DIRECTIONS.each do |dir|
      if dir != direction
        assert_IF_not_executed(("facing_" + dir.to_s).to_sym)
        assert_IF_executed(("not_facing_" + dir.to_s).to_sym)
      end
    end
  end

  def assert_IF_executed(condition)
    executed = false
    IF(condition) {
      executed = true
    }
    ELSE {
      assert false,"#{condition.to_s} holds, but we executed the else block?!?!?"
    }
    assert executed,"#{condition.to_s} holds, however we didn't execute the block for it"
  end

  def assert_IF_not_executed(condition)
    executed_else = false
    IF(condition) {
      assert false,"#{condition.to_s} doesn't hold, yet we executed the block!"
    }
    ELSE {
      executed_else = true
    }
    assert executed_else,"#{condition.to_s} doesn't hold, but we didn't execute the else block!"
  end
end
