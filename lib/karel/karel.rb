module Karel
  # The robot itself.  Knows only its internal state, not much about where it is
  class Karel
    attr_reader :direction
    attr_reader :num_beepers

    def initialize
      reset
    end

    def reset
      @direction = :north
      @num_beepers = 0
    end

    def put_beeper_in_bag
      @num_beepers += 1
    end

    def remove_beeper_from_bag
      raise Explosion if @num_beepers <= 0
      @num_beepers -= 1
    end

    def turnleft
      new_index = DIRECTIONS.index(@direction) + 1
      new_index = 0 if new_index >= DIRECTIONS.size
      @direction = DIRECTIONS[new_index]
    end

    def to_s
      STRINGS[direction]
    end

    private 
    DIRECTIONS = [:north,:west,:south,:east]
    STRINGS = {
      :north => '^',
      :west => '<',
      :south => 'v',
      :east => '>',
    }
  end
end
