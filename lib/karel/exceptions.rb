module Karel
  # Thrown when Karel does something that causes him to explode
  class Explosion < Exception; end
  # Thrown if the world was not created in a valid state
  class InvalidWorld < Exception; end
  # Thrown when a square is occupied when an operation requires it not to be
  class SquareOccupied < Exception; end
  # Throw when there is no beeper on a square when an operation require there to be
  class NoBeeper < Exception; end
end