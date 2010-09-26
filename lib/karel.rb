module Karel
  # Create the world with the given initialization string
  def WORLD(string)
    THE_WORLD.create_from_string(string)
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
      raise NoKarel unless @karel
      fill_in_empty_spaces
    end

    def remove_beeper(row,column)
      self[row,column].pick_beeper
    end

    def add_beeper(row,column)
      self[row,column].put_beeper
    end

    # Set the location of Karel
    #
    # location - an array of size 2, with the row/column where karel should be
    #
    # Raises an Explosion if you try to put Karel where there is a wall
    def karel=(location)
      raise Explosion if self[*location].wall?
      @karel = location
    end

    # Provides access to the square at the given row/column
    def [](row,column)
      @world[row][column]
    end

    # Returns the string representation, which looks like the 
    # the string used to construct this
    def to_s
      string = ""
      @height.times do |row|
        @width.times do |column|
          kr,kc = karel
          if (kr == row) && (kc == column)
            string += "K"
          else
            string += self[row,column].to_s
          end
        end
        string += "\n"
      end
      string
    end

    private

    SQUARE_FACTORIES = {
      'B' => lambda { Square.new(true) },
      'W' => lambda { Wall.new },
      ' ' => lambda { Square.new },
      'K' => lambda { Square.new },
    }

    # Given a character, returns the square type
    # that should go there
    def square_for(square)
      raise InvalidWorld,"Square type #{square} is not valid" if SQUARE_FACTORIES[square].nil?
      SQUARE_FACTORIES[square].call
    end

    def fill_in_empty_spaces
      @height.times do |row|
        @world[row] = [] if @world[row].nil?
        @width.times do |column|
          @world[row][column] = Square.new if @world[row][column].nil?
        end
      end
    end
  end

  THE_WORLD = World.new

  class Explosion < Exception; end
  class InvalidWorld < Exception; end
  class NoKarel < Exception; end
  class SquareOccupied < Exception; end
  class NoBeeper < Exception; end

  class Square
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

  class Wall
    def wall?; true; end
    def beeper?; false; end
    def to_s; "W"; end
    def put_beeper; raise SquareOccupied; end
    def pick_beeper; raise NoBeeper; end
  end
end
