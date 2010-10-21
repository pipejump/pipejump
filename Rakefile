require "rubygems"
require "bundler/setup"
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pipejump-client"
    gem.summary = %Q{Pipejump API Ruby client}
    gem.description = %Q{Pipejump API Ruby client}
    gem.email = "marcin@pipejump.com"
    gem.homepage = "http://github.com/marcinbunsch/pipejump-client"
    gem.authors = ["Marcin Bunsch"]
    gem.add_development_dependency "bundler", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'

begin
  require 'rcov/rcovtask'
  
  desc "Run rcov for rspec"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/pipejump/*_spec.rb', 'spec/pipejump/**/*_spec.rb']
    t.spec_opts = %w{--color}
    t.rcov = true
    t.rcov_opts = %w{--html --exclude osx\/objc,gems\/,spec\/}
    t.rcov_opts << %[-o "coverage"]
  end

rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/pipejump/*_spec.rb', 'spec/pipejump/**/*_spec.rb']
  t.spec_opts = %w{--color}
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pipejump-client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
