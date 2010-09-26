require 'rake/clean'
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rcov/rcovtask'

Rcov::RcovTask.new(:rcov) do |t|
  t.libs << "test"
  t.libs << "ext"
  t.test_files = FileList['test/test*.rb']
  t.output_dir = 'coverage'
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "ext"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*", "ext/**/*")
  rd.title = 'Your application title'
end

spec = eval(File.read('karel.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/tc_*.rb']
end

task :default => :test
