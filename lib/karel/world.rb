module Karel
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

    # True if the square could be moved into by Karel
    def clear?(row,column)
      if in_bounds?(row,column)
        !self[row,column].wall?
      else
        false
      end
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
end
