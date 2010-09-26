module Karel
  # Thrown when Karel does something that causes him to explode
  class Explosion < Exception; end
  # Thrown if the world was not created in a valid state
  class InvalidWorld < Exception; end
  # Thrown when a square is occupied when an operation requires it not to be
  class SquareOccupied < Exception; end
  # Thrown when there is no beeper on a square when an operation require there to be
  class NoBeeper < Exception; end
  # Thrown when a subroutine is defined that has a bad or not-allowed name
  class BadSubroutine < Exception; end
end
