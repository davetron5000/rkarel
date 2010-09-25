module Karel
  def WORLD(x)
    THE_WORLD
  end
  def IS(string)
    THE_WORLD.IS(string)
  end
  class World
    attr_reader :karel
    def IS(definition)
      @world = []
      w = 0
      h = 0
      x = 0
      y = 0
      definition.split(/\n/).each do |row|
        w = row.length if row.length > w 
        row.split(//).each do |square|
          @karel = [x,y] if square == 'K'
          if square == 'B' || square == 'W'
            @world[x] ||= []
            if square == 'B'
              @world[x][y] = Square.new(true)
            elsif square == 'W'
              @world[x][y] = Wall.new
            else
              raise "#{square} is not handled"
            end
          end
          y += 1
        end
        y = 0
        h += 1 
        x += 1
      end
      @karel = [0,0]
      @width = w
      @height = h
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

    def [](x,y)
      if @world[x].nil?
        EMPTY_SQUARE
      elsif @world[x][y].nil?
        EMPTY_SQUARE
      else
        @world[x][y]
      end
    end

    def to_s
      string = ""
      @world.each_index do |x|
        @width.times do |y|
          kx,ky = karel
          if (kx == x) && (ky == y)
            string += "K"
          else
            string += self[x,y].to_s
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
    def initialize(beeper)
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

  EMPTY_SQUARE = Square.new(false)

  THE_WORLD = World.new
end
