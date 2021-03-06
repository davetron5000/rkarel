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
      @direction = Karel.left_of(@direction)
    end

    def to_s
      STRINGS[direction]
    end

    def self.left_of(direction)
      new_index = DIRECTIONS.index(direction) + 1
      new_index = 0 if new_index >= DIRECTIONS.size
      DIRECTIONS[new_index]
    end

    def self.right_of(direction)
      new_index = DIRECTIONS.index(direction) - 1
      new_index = DIRECTIONS.size - 1 if new_index < 0
      DIRECTIONS[new_index]
    end

    def self.coordinates_after_move_from(direction,x,y)
      if direction == :north
        [x-1,y]
      elsif direction == :south
        [x+1,y]
      elsif direction == :west
        [x,y-1]
      elsif direction == :east
        [x,y+1]
      end
    end

    DIRECTIONS = [:north,:west,:south,:east]

    private 
    STRINGS = {
      :north => '^',
      :west => '<',
      :south => 'v',
      :east => '>',
    }
  end
end
