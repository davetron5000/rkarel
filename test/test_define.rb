require 'test/unit'
require 'karel'

class TestDefine < Test::Unit::TestCase
  include Karel

  def test_define
    WORLD <<END
K  W
    
    
END
    DEFINE('TURNRIGHT') {
      ITERATE(3.TIMES) {
        TURNLEFT()
      }
    }
    TURNRIGHT()
    MOVE()
    assert [0,1],THE_WORLD.karel
  end

  def test_good_names 
    DEFINE('A9A') {}
    DEFINE('A_A') {}
    DEFINE('A_______A') {}
    A9A()
    A_A()
    A_______A()
  end

  def test_bad_names
    WORLD <<END
K  W
    
    
END
    assert_raises BadSubroutine do
      DEFINE('turn_right') { }
    end
    assert_raises BadSubroutine do
      DEFINE('A') { }
    end
    assert_raises BadSubroutine do
      DEFINE('9A') { }
    end
    assert_raises BadSubroutine do
      DEFINE('A9') { }
    end
  end

  def test_method_missing_still_behaves
    WORLD <<END
K  W
    
    
END
    assert_raises NoMethodError do
      BLAH()
    end
    assert_raises NoMethodError do
      BLAH(1,2,3)
    end
  end
end
