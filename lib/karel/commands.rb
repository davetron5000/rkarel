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

    @last_condition = nil
    def IF(condition,&block)
      if condition_met? condition
        block.call
      end
      @last_condition = condition
    end

    def ELSE(&block)
      raise "No IF with this ELSE!" if @last_condition.nil?
      condition = @last_condition
      @last_condition = nil
      unless (condition_met? condition)
        block.call
      end
    end

    def condition_met?(condition)
      raise "No such condition #{condition}" unless CONDITIONS[condition]
      CONDITIONS[condition].call(*THE_WORLD.karel)
    end

    CONDITIONS = {
      :on_beeper    => lambda{ |row,column| THE_WORLD.clear?(row,column) && THE_WORLD[row,column].beeper? },
      :front_clear  => lambda{ |row,column| THE_WORLD.clear?(*Karel.coordinates_after_move_from(KAREL.direction,row,column)) },
      :left_clear   => lambda{ |row,column| THE_WORLD.clear?(*Karel.coordinates_after_move_from(Karel.left_of(KAREL.direction),row,column)) },
      :right_clear  => lambda{ |row,column| THE_WORLD.clear?(*Karel.coordinates_after_move_from(Karel.right_of(KAREL.direction),row,column)) },
      :facing_north => lambda{ |row,column| KAREL.direction == :north },
      :facing_south => lambda{ |row,column| KAREL.direction == :south },
      :facing_east  => lambda{ |row,column| KAREL.direction == :east },
      :facing_west  => lambda{ |row,column| KAREL.direction == :west },

      :not_on_beeper    => lambda{ |row,column| !CONDITIONS[:on_beeper].call(row,column) },
      :front_not_clear  => lambda{ |row,column| !CONDITIONS[:front_clear].call(row,column) },
      :left_not_clear   => lambda{ |row,column| !CONDITIONS[:left_clear].call(row,column) },
      :right_not_clear  => lambda{ |row,column| !CONDITIONS[:right_clear].call(row,column) },
      :not_facing_north => lambda{ |row,column| !CONDITIONS[:facing_north].call(row,column) },
      :not_facing_south => lambda{ |row,column| !CONDITIONS[:facing_south].call(row,column) },
      :not_facing_east  => lambda{ |row,column| !CONDITIONS[:facing_east].call(row,column) },
      :not_facing_west  => lambda{ |row,column| !CONDITIONS[:facing_west].call(row,column) },
    }

    CONDITIONS.each_key do |condition|
      define_method condition do
        condition
      end
    end
  end

end
class Fixnum
  def TIMES
    self
  end
end
