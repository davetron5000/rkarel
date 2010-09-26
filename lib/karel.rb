require 'karel/commands'
require 'karel/exceptions'
require 'karel/karel'
require 'karel/square'
require 'karel/world'

module Karel
  include Commands

  THE_WORLD = World.new
  KAREL = Karel.new
end
