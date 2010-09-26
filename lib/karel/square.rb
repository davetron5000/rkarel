module Karel
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
