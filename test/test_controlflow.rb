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
    executed = false
    IF(front_clear) {
      executed = true
    }
    assert executed,"Front was clear, but we didn't execute the block"
    IF (front_not_clear){
      assert false
    }
    MOVE()
    IF(front_clear) {
      assert false
    }
    executed = false
    IF (front_not_clear) {
      executed = true
    }
    assert executed,"Front was not clear, but we didn't execute the block"
  end

  def test_left_clear
    WORLD <<END
W K

 
END
    executed = false
    IF(left_clear) {
      executed = true
    }
    assert executed,"Left was clear, but we didn't execute the block"
    IF(left_not_clear) {
      assert false
    }
    TURNLEFT()
    MOVE()
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    IF(left_clear) {
      assert false
    }
    executed = false
    IF(left_not_clear) {
      executed = true
    }
    assert executed,"Left wasn't clear, but we didn't execute the block"
  end

  def test_right_clear
    WORLD <<END
K W 

  
END
    executed = false
    IF(right_clear) {
      executed = true
    }
    assert executed,"Right was clear, but we didn't execute the block"
    IF(right_not_clear) {
      assert false
    }
    TURNLEFT()
    TURNLEFT()
    TURNLEFT()
    MOVE()
    TURNLEFT()
    IF(right_clear) {
      assert false
    }
    executed = false
    IF(right_not_clear) {
      executed = true
    }
    assert executed,"Right wasn't clear, but we didn't execute the block"
  end
  
  def test_on_beeper
    WORLD <<END
 B 
 K
  
END
    MOVE()
    executed = false
    IF(on_beeper) {
      executed = true
    }
    IF(not_on_beeper) {
      assert false
    }
    assert executed,"We were on a bepper, but the block didn't execute"
    PICKBEEPER()
    assert !THE_WORLD[0,1].beeper?
    assert_equal 1,KAREL.num_beepers
    TURNLEFT()
    TURNLEFT()
    MOVE()
    IF(on_beeper) {
      assert false
    }
    executed = false
    IF(not_on_beeper) {
      executed = true
    }
    assert executed,"We were not on a bepper, but the block didn't execute"
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
      assert true
    }
    IF (("not_facing_" + direction.to_s).to_sym) {
      assert false,"We are facing #{direction.to_is}, but the block executed for not_facing it!"
    }
    Karel::DIRECTIONS.each do |dir|
      if dir != direction
        IF (("facing_" + dir.to_s).to_sym) {
          assert false,"Not expected to be facing #{dir.to_s}"
        }
        executed = false
        IF (("not_facing_" + dir.to_s).to_sym) {
          executed = true
        }
        assert executed,"We are NOT facing #{dir.to_s}, however the block for not_ didn't execute!"
      end
    end
  end
end
