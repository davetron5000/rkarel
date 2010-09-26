module Karel
  module Commands
    # Create the world with the given initialization string
    def WORLD(string)
      THE_WORLD.create_from_string(string)
    end

    # Moves Karel forward one square
    def MOVE
      x,y = THE_WORLD.karel
      if KAREL.direction == :north
        THE_WORLD.karel=[x-1,y]
      elsif KAREL.direction == :south
        THE_WORLD.karel=[x+1,y]
      elsif KAREL.direction == :west
        THE_WORLD.karel=[x,y-1]
      elsif KAREL.direction == :east
        THE_WORLD.karel=[x,y+1]
      end
    end

    # Turns karel to the left in place
    def TURNLEFT
      KAREL.turnleft
    end

    def PICKBEEPER
      karel = THE_WORLD.karel
      begin
      THE_WORLD.remove_beeper(*karel)
      KAREL.put_beeper_in_bag
      rescue NoBeeper => x
        raise Explosion
      end
    end

    def PUTBEEPER
      karel = THE_WORLD.karel
      KAREL.remove_beeper_from_bag
      THE_WORLD.add_beeper(*karel)
    end

    def ITERATE(num,&block)
      num.times { block.call }
    end

  end

end
class Fixnum
  def TIMES
    self
  end
end
