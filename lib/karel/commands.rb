module Karel
  module Commands
    # Create the world with the given initialization string
    def WORLD(string)
      THE_WORLD.create_from_string(string)
    end

    # Moves Karel forward one square
    def MOVE
      x,y = Karel.coordinates_after_move_from(KAREL.direction,*THE_WORLD.karel)
      THE_WORLD.karel=[x,y]
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

    def IF(condition,&block)
      if condition_met? condition
        block.call
      end
    end

    def front_clear
      :front_clear
    end

    def condition_met?(condition)
      raise "No such condition #{condition}" unless CONDITIONS[condition]
      CONDITIONS[condition].call(*THE_WORLD.karel)
    end


    private 

    CONDITIONS = {
      :on_beeper =>    lambda{ |row,column| THE_WORLD.clear?(row,column) && THE_WORLD[row][column].beeper? },
      :front_clear =>  lambda{ |row,column| THE_WORLD.clear?(*Karel.coordinates_after_move_from(KAREL.direction,row,column)) },
      :left_clear =>   lambda{ |row,column| false },
      :right_clear =>  lambda{ |row,column| false },
      :facing_north => lambda{ |row,column| false },
      :facing_south => lambda{ |row,column| false },
      :facing_east =>  lambda{ |row,column| false },
      :facing_west =>  lambda{ |row,column| false },
    }
  end

end
class Fixnum
  def TIMES
    self
  end
end
