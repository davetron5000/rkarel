require 'karel/commands'

module Karel
  # A very basic and very hacky syntax checker.  This won't ensure the program runs
  # and is pretty lame overall, but it more or less gets the job done
  class SyntaxChecker
    def initialize
      @builtins = []
      Commands.public_instance_methods.each do |method|
        @builtins << method if method =~ /^[A-Z_]*$/
      end
      @control = [ 'WHILE', 'IF', 'ELSE', 'ITERATE' ]
    end

    def valid?(code)
      line_number = 1
      @errors = {}
      in_world = false
      defines = []
      code.split(/\n/).each do |line|
        line_number += 1
        trimmed = line.strip.gsub(/\(\)/,'').strip
        if in_world
          if trimmed =~ /^END\s*$/
            in_world = false
          else
            if trimmed =~ /^[ KWB]*$/
              # ok
            else
              @errors[line_number] = "Bad world definition: #{trimmed}"
            end
          end
        elsif (trimmed =~ /^WORLD\s+<<END$/)
          in_world = true
        else
          next if trimmed =~/^\s*$/
          next if trimmed =~/^\s*#.*$/
          if trimmed =~ /^DEFINE\s*\(\s*["'](.[^"']*)["']\s*\)\s*\{\s*$/
            define = $1
            if define =~ /^[A-Z_]*$/
              defines << define
            else
              @errors[line_number] = "Bad DEFINE symbol #{define}"
            end
          else
            to_the_bone = trimmed.gsub(/[^A-Z_].*$/,'')
            if @control.include? to_the_bone
              if trimmed =~ /^#{to_the_bone}\s*\((.*)\)\s*\{\s*$/
                condition = $1
                if to_the_bone == 'ITERATE'
                  if condition =~ /^\s*[0-9]\.TIMES\s*$/
                    # ok
                  else
                    @errors[line_number] = "Bad #{to_the_bone} condition: #{condition}"
                  end
                else
                  if (trimmed =~ /^ELSE/) 
                    @errors[line_number] = "Bad #{to_the_bone} statement: #{trimmed}"
                  end
                  if condition =~ /^[a-z_]+$/
                    # ok
                  else
                    @errors[line_number] = "Bad #{to_the_bone} condition: #{condition}"
                  end
                end
              else
                if trimmed =~ /^ELSE\s*\{\s*$/
                  # ok
                else
                  @errors[line_number] = "Bad #{to_the_bone} statement: #{trimmed}"
                end
              end
            elsif trimmed =~ /^\s*\}\s*$/
              # ignore
            else
              @errors[line_number] = "Unknown symbol #{trimmed}" unless (@builtins.include? trimmed) || (defines.include? trimmed)
            end
          end
        end
      end
      @errors.empty?
    end

    def errors; @errors; end
  end
end
