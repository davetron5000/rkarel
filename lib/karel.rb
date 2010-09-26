module Karel
  def WORLD(string)
    THE_WORLD.IS(string)
  end
  class World
    attr_reader :karel
    def IS(definition)
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
          if square == 'B' || square == 'W'
            if square == 'B'
              @world[row][column] = Square.new(true)
            elsif square == 'W'
              @world[row][column] = Wall.new
            else
              raise "Square type #{square} is not handled"
            end
          else
            @world[row][column] = Square.new
          end
          column += 1
        end
        column = 0
        row += 1
      end
      @karel = [0,0]
      @height.times do |row|
        @world[row] = [] if @world[row].nil?
        @width.times do |column|
          @world[row][column] = Square.new if @world[row][column].nil?
        end
      end
    end

    def width
      @width
    end

    def height
      @height
    end

    def karel=(location)
      raise Explosion if self[*location].wall?
      @karel = location
    end

    def [](row,column)
      @world[row][column]
    end

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
  end

  class Explosion < Exception
  end

  class Square
    def initialize(beeper=false)
      @beeper = beeper
    end

    def wall?; false; end
    def beeper?; @beeper; end

    def pick_beeper; @beeper = false; end
    def put_beeper; @beeper = true; end
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
  end

  THE_WORLD = World.new
end
