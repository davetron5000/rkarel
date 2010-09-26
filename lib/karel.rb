module Karel
  def WORLD(string)
    THE_WORLD.IS(string)
  end
  class World
    attr_reader :karel
    def IS(definition)
      @world = []
      @width = 0
      x = 0
      y = 0
      definition.split(/\n/).each do |row|
        @width = row.length if row.length > @width
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
        x += 1
      end
      @karel = [0,0]
      @height = x
      @width.times do |x|
        @world[x] = [] if @world[x].nil?
        @height.times do |y|
          @world[x][y] = Square.new if @world[x][y].nil?
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

    def [](x,y)
      @world[x][y]
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
