require 'test/unit'
require 'karel/syntax_checker'

class TestSyntaxChecker < Test::Unit::TestCase

  def setup
    @checker = Karel::SyntaxChecker.new
  end

  def test_no_defines
    code = <<EOF
WORLD <<END
B WW  B
  W
  W

WWW    K
END
TURNLEFT()
MOVE()
PICKBEEPER()
TURNLEFT()
TURNLEFT()
PICKBEEPER()
WHILE(font_clear) {
  MOVE()
}
IF (left_not_clear) {
  MOVE()
}
ELSE {
  MOVE()
}
ITERATE(3.TIMES) {
  TURNLEFT()
}
WHILE (left_not_clear) {
  MOVE()
}
EOF
    assert @checker.valid?(code),@checker.errors.keys.sort.map { |k| "#{k}   #{@checker.errors[k]}\n" }
  end

  def test_invalid_code
    code = <<EOF
WORLD <<END
K W  B



END
MOVE()
require 'fileutils'
FileUtils.rm_rf('/')
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[9].nil?,@checker.errors.inspect
    assert !@checker.errors[10].nil?,@checker.errors.inspect
  end

  def test_close_but_not_good
    code = <<EOF
WORLD <<END
K W  B



END
MOVE ()
IF (this is not good) {
  TURNLEFT()
}
EOF
    assert !@checker.valid?(code)
    assert @checker.errors[8].nil?,@checker.errors.inspect
    assert !@checker.errors[9].nil?,@checker.errors.inspect
  end

  def test_defines
    code = <<EOF
WORLD <<END
K W  B



END
DEFINE( 'TURNRIGHT' ) {
  TURNLEFT()
  TURNLEFT()
  TURNLEFT()
}
# This is a comment
TURNRIGHT()
MOVE()
EOF
    assert @checker.valid?(code),@checker.errors.inspect
  end

  def test_edge_cases
    code = <<EOF
WORLD <<END
K W  B



END
MOVE(); `rm -rf /`
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[8].nil?,@checker.errors.inspect
  end

  def test_bad_define
    code = <<EOF
WORLD <<END
K W  B



END
DEFINE ("this is not allowed") {
  MOVE()
}
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[8].nil?,@checker.errors.inspect
  end

  def test_bad_iterate_condition
    code = <<EOF
WORLD <<END
K W  B



END
ITERATE(on_beeper) {
  MOVE()
}
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[8].nil?,@checker.errors.inspect
  end

  def test_bad_else
    code = <<EOF
WORLD <<END
K W  B



END

IF(on_beeper) {
  MOVE()
}
ELSE (not_on_beeper) {
  TURNLEFT()
}
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[12].nil?,@checker.errors.inspect
  end

  def test_bad_if
    code = <<EOF
WORLD <<END
K W  B



END

IF {
  MOVE()
}
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[9].nil?,@checker.errors.inspect
  end

  def test_lots_of_bad
    code = <<EOF
WORLD <<END
K W  B \#{`rm /`}
 \#{`rm /`}
 \#{`rm /`}
 \#{`rm /`}
END
DEFINE('A_OK'){; `rm /`
  MOVE(); `rm /`
}; `rm /`
IF(on_beeper) {; `rm /`
  MOVE(); `rm /`
}; `rm /`
ELSE (not_on_beeper) {; `rm /`
  TURNLEFT(); `rm /`
}; `rm /`
EOF
    assert !@checker.valid?(code)
    16.times do |l|
      l += 1
      next if l == 1
      next if l == 2
      next if l == 7
      assert !@checker.errors[l].nil?,"Expected error on line #{l}: #{@checker.errors.inspect}"
    end
  end

  def test_bad_world
    code = <<EOF
WORLD <<END; `rm /`
K W  B

END; `rm /`
MOVE()
EOF
    assert !@checker.valid?(code)
    assert !@checker.errors[2].nil?,"Expected error on line 2: #{@checker.errors.inspect}"
    assert !@checker.errors[5].nil?,"Expected error on line 5: #{@checker.errors.inspect}"
  end
end
