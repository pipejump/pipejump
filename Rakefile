require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pipejump-client"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "marcin@applicake.com"
    gem.homepage = "http://github.com/marcinbunsch/pipejump-client"
    gem.authors = ["Marcin Bunsch"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin

  require 'rcov/rcovtask'
  require 'spec/rake/spectask'
  
  desc "Run rcov for rspec"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    # t.spec_opts = ['--options', "/spec/spec.opts"]
    t.spec_files = FileList['spec/pipejump/*']
    t.rcov = true
    t.rcov_opts = %w{--html --rails --exclude osx\/objc,gems\/,spec\/,features\/test\/,stories\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end

rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pipejump-client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
