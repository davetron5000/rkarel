require 'fixnum_TIMES.rb'
module Karel
  module Commands
    INFINITE_LOOP_NUM_STEPS = 1000
    # Create the world with the given initialization string
    def WORLD(string)
      @subroutines ||= {}
      world_instance.create_from_string(string,karel_instance)
      #unless @silent
      #  puts "Initial State"
      #  puts THE_WORLD.to_s
      #end
    end

    def karel_instance; KAREL; end
    def world_instance; THE_WORLD; end
    
    def DEBUG
      @debug = true
      @silent = false
    end

    def SILENT
      @silent = true
      @debug = false
    end

    # Moves Karel forward one square
    def MOVE
      x,y = Karel.coordinates_after_move_from(karel_instance.direction,*world_instance.karel)
      world_instance.karel=[x,y]
      debug_command('MOVE')
    end

    # Turns karel to the left in place
    def TURNLEFT
      karel_instance.turnleft
      debug_command('TURNLEFT')
    end

    def PICKBEEPER
      karel = world_instance.karel
      begin
      world_instance.remove_beeper(*karel)
      karel_instance.put_beeper_in_bag
      rescue NoBeeper => x
        raise Explosion
      end
      debug_command('PICKBEEPER')
    end

    def PUTBEEPER
      karel = world_instance.karel
      karel_instance.remove_beeper_from_bag
      world_instance.add_beeper(*karel)
      debug_command('PUTBEEPER')
    end

    def DEFINE(name,&block)
      raise BadSubroutine unless subroutine_name_ok?(name)
      @subroutines ||= {}
      @subroutines[name.to_sym] = block;
    end

    # Handles calling subroutines defined
    def method_missing(sym,*args)
      if !args || args.size == 0
        if @subroutines[sym]
          puts "CALLING #{sym}" if @debug
          @subroutines[sym].call
        else
          super.method_missing(sym,args)
        end
      else
        super.method_missing(sym,args)
      end
    end

    def ITERATE(num,&block)
      num.times { block.call }
    end

    def WHILE(condition,&block)
      steps = 0
      while (condition_met? condition)
        block.call
        steps += 1
        raise PossibleInfiniteLoop if steps > INFINITE_LOOP_NUM_STEPS
      end
    end

    @last_condition = nil
    def IF(condition,&block)
      if condition_met? condition
        block.call
      end
      @last_condition = condition
    end

    def ELSE(&block)
      raise "No IF with this ELSE!" if @last_condition.nil?
      condition = @last_condition
      @last_condition = nil
      unless (condition_met? condition)
        block.call
      end
    end

    def condition_met?(condition)
      raise "No such condition #{condition}" unless CONDITIONS[condition]
      CONDITIONS[condition].call(world_instance,karel_instance,*world_instance.karel)
    end

    def subroutine_name_ok?(name)
      name =~ /^[A-Z][A-Z_0-9]*[A-Z]$/
    end

    def debug_command(command)
      if @debug
        puts "#{karel_instance.num_beepers} beepers> #{command}"
        puts world_instance.to_s
      end
    end

    CONDITIONS = {
      :on_beeper    => lambda{ |world,karel,row,column| world.clear?(row,column) && world[row,column].beeper? },
      :front_clear  => lambda{ |world,karel,row,column| world.clear?(*Karel.coordinates_after_move_from(karel.direction,row,column)) },
      :left_clear   => lambda{ |world,karel,row,column| world.clear?(*Karel.coordinates_after_move_from(Karel.left_of(karel.direction),row,column)) },
      :right_clear  => lambda{ |world,karel,row,column| world.clear?(*Karel.coordinates_after_move_from(Karel.right_of(karel.direction),row,column)) },
      :facing_north => lambda{ |world,karel,row,column| karel.direction == :north },
      :facing_south => lambda{ |world,karel,row,column| karel.direction == :south },
      :facing_east  => lambda{ |world,karel,row,column| karel.direction == :east },
      :facing_west  => lambda{ |world,karel,row,column| karel.direction == :west },

      :not_on_beeper    => lambda{ |world,karel,row,column| !CONDITIONS[:on_beeper].call(world,karel,row,column) },
      :front_not_clear  => lambda{ |world,karel,row,column| !CONDITIONS[:front_clear].call(world,karel,row,column) },
      :left_not_clear   => lambda{ |world,karel,row,column| !CONDITIONS[:left_clear].call(world,karel,row,column) },
      :right_not_clear  => lambda{ |world,karel,row,column| !CONDITIONS[:right_clear].call(world,karel,row,column) },
      :not_facing_north => lambda{ |world,karel,row,column| !CONDITIONS[:facing_north].call(world,karel,row,column) },
      :not_facing_south => lambda{ |world,karel,row,column| !CONDITIONS[:facing_south].call(world,karel,row,column) },
      :not_facing_east  => lambda{ |world,karel,row,column| !CONDITIONS[:facing_east].call(world,karel,row,column) },
      :not_facing_west  => lambda{ |world,karel,row,column| !CONDITIONS[:facing_west].call(world,karel,row,column) },
    }

    CONDITIONS.each_key do |condition|
      define_method condition do
        condition
      end
    end
  end

end
