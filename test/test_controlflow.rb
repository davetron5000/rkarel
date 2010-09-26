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
    IF(front_clear) {
      MOVE()
    }
    assert_equal [1,0],THE_WORLD.karel
    IF(front_clear) {
      assert false
    }
  end

  def test_left_clear
    WORLD <<END
W K

 
END
    IF(left_clear) {
      TURNLEFT()
      MOVE()
      TURNLEFT()
      TURNLEFT()
      TURNLEFT()
    }
    assert_equal [0,1],THE_WORLD.karel
    IF(left_clear) {
      assert false
    }
  end

  def test_right_clear
    WORLD <<END
K W 

  
END
    IF(right_clear) {
      TURNLEFT()
      TURNLEFT()
      TURNLEFT()
      MOVE()
      TURNLEFT()
    }
    assert_equal [0,1],THE_WORLD.karel
    IF(right_clear) {
      assert false
    }
  end
  
  def test_on_beeper
    WORLD <<END
 B 
 K
  
END
    MOVE()
    IF(on_beeper) {
      PICKBEEPER()
      TURNLEFT()
      TURNLEFT()
      MOVE()
    }
    assert_equal [1,1],THE_WORLD.karel
    assert_equal 1,KAREL.num_beepers
    assert !THE_WORLD[0,1].beeper?
    IF(on_beeper) {
      assert false
    }
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

  def assert_facing(direction)
    IF (("facing_" + direction.to_s).to_sym) {
      # success
    }
    Karel::DIRECTIONS.each do |dir|
      if dir != direction
        IF (("facing_" + dir.to_s).to_sym) {
          assert false,"Not expected to be facing #{dir.to_s}"
        }
      end
    end
  end
end
