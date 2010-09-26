module Karel
  # Create the world with the given initialization string
  def WORLD(string)
    THE_WORLD.create_from_string(string)
  end

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

  def TURNLEFT
    KAREL.turnleft
  end

  # The world in which Karel operates.  
  class World

    attr_reader :karel
    attr_reader :width
    attr_reader :height

    # Creates the world from a string that is a multi-line representation of the world.
    # This isn't the constructor because our DSL requires uppercase and we don't want
    # warnings by creating the world twice (once when declaring it as a constant in the Karel
    # module and once inside the module method WORLD).
    def create_from_string(definition)
      @karel = nil
      KAREL.reset
      @world = []
      @width = 0
      row = 0
      column = 0
      rows = definition.split(/\n/)
      @height = rows.size
      rows.each do |row_data|
        @width = row_data.length if row_data.length > @width
        row_data.split(//).each do |square|
          @karel = [row,column] if square == 'K'
          @world[row] ||= []
          @world[row][column] = square_for(square)
          column += 1
        end
        column = 0
        row += 1
      end
      raise InvalidWorld,"There is no Karel in this World" unless @karel
      fill_in_empty_spaces
    end

    # Removes a beeper from the world at the given row/column
    #
    # raises a NoBeeper exception if there is no beeper at those coordinates.  
    def remove_beeper(row,column)
      self[row,column].pick_beeper
    end

    # Adds a beeper tot he world at the given row/column
    #
    # raises a SquareOccupied exception if there is a beeper or wall at those coordinates.  
    def add_beeper(row,column)
      self[row,column].put_beeper
    end

    # Set the location of Karel
    #
    # location - an array of size 2, with the row/column where karel should be
    #
    # Raises an Explosion if you try to put Karel where there is a wall
    def karel=(location)
      raise Explosion,"#{location.inspect} is out of bounds" unless in_bounds?(*location)
      raise Explosion if self[*location].wall?
      @karel = location
    end

    # Provides access to the square at the given row/column
    #
    # Returns a Square instance, on which you can call handy methods like beeper? and wall?
    def [](row,column)
      @world[row][column]
    end

    # Returns the string representation, which looks like the 
    # the string used to construct this
    def to_s
      string = "+"
      @width.times { string += '-' }
      string += "+\n"
      @height.times do |row|
        string += "|"
        @width.times do |column|
          kr,kc = karel
          if (kr == row) && (kc == column)
            string += KAREL.to_s
          else
            string += self[row,column].to_s
          end
        end
        string += "|\n"
      end
      string += "+"
      @width.times { string += '-' }
      string += "+\n"
      string
    end

    private

    SQUARE_FACTORIES = {
      'B' => lambda { FreeSquare.new(true) },
      'W' => lambda { Wall.new },
      ' ' => lambda { FreeSquare.new },
      'K' => lambda { FreeSquare.new },
    }

    # Given a character, returns the square type
    # that should go there
    def square_for(square)
      raise InvalidWorld,"Square type #{square} is not valid" if SQUARE_FACTORIES[square].nil?
      SQUARE_FACTORIES[square].call
    end

    def in_bounds?(row,column)
      if row < 0 || column < 0
        false
      elsif row >= @height
        false
      elsif column >= @width
        false
      else
        true
      end
    end

    def fill_in_empty_spaces
      @height.times do |row|
        @world[row] = [] if @world[row].nil?
        @width.times do |column|
          @world[row][column] = FreeSquare.new if @world[row][column].nil?
        end
      end
    end
  end

  class Karel
    attr_reader :direction
    def initialize
      reset
    end

    def reset
      @direction = :north
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

  THE_WORLD = World.new
  KAREL = Karel.new

  # Thrown when Karel does something that causes him to explode
  class Explosion < Exception; end
  # Thrown if the world was not created in a valid state
  class InvalidWorld < Exception; end
  # Thrown when a square is occupied when an operation requires it not to be
  class SquareOccupied < Exception; end
  # Throw when there is no beeper on a square when an operation require there to be
  class NoBeeper < Exception; end

  # A square on the board
  class Square; end

  # A square that can hold a beeper, or Karel.
  class FreeSquare < Square
    def initialize(beeper=false)
      @beeper = beeper
    end

    def wall?; false; end

    def beeper?; @beeper; end

    def pick_beeper
      raise NoBeeper unless beeper?
      @beeper = false
    end

    def put_beeper
      raise SquareOccupied if beeper?
      @beeper = true
    end

    def to_s
      if beeper?
        "B"
      else
        " "
      end
    end
  end

  # A wall square
  class Wall < Square
    def wall?; true; end
    def beeper?; false; end
    def to_s; "W"; end
    def put_beeper; raise SquareOccupied; end
    def pick_beeper; raise NoBeeper; end
  end
end
