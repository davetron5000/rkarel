spec = Gem::Specification.new do |s| 
  s.name = 'karel'
  s.version = '0.1.0'
  s.author = 'Dave Copeland'
  s.email = 'davetron5000@gmail.com'
  s.homepage = 'http://www.naildrivin5.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'An implementation of Karel the Robot as a Ruby DSL'
  s.description = <<END
This is a ruby implementation of Karel The Robot, a 
programming language designed for extreme beginners.   It concerns controlling
a robot, named Karel, in a grid-based world comprised of walls and beepers.  Karel can pick up and put down beepers, move
forward, and turn left.  Karel can also detect things about his environment.
END
# Add your other files here if you make them
  s.files = %w(
bin/karel
ext/fixnum_TIMES.rb
lib/karel/commands.rb
lib/karel/exceptions.rb
lib/karel/karel.rb
lib/karel/square.rb
lib/karel/syntax_checker.rb
lib/karel/world.rb
lib/karel.rb
README.rdoc
karel.rdoc
  )
  s.require_paths << 'lib'
  s.require_paths << 'ext'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','karel.rdoc']
  s.rdoc_options << '--title' << 'Karel The Robot' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'karel'
  s.add_dependency('gli', '>= 1.1.1')
end
