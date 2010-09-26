require 'test/unit'
require 'karel'

# This test ensures that we can maintain two completely isolated
# instances of Karel's world going
class TestNonGlobal < Test::Unit::TestCase
  def test_two_worlds
    world1 = Karel::World.new
    world_string = <<END
KWWB


END
    world1.create_from_string(world_string,Karel::Karel.new) 
    world2 = Karel::World.new
    world_string = <<END
BWWK
 W
   
END
    world2.create_from_string(world_string,Karel::Karel.new) 
    assert world1.to_s != world2.to_s,"Worlds should differ; got for both:\n#{world1.to_s}"
  end
end
