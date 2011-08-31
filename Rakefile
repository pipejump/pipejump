require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'rcov/rcovtask'

  desc "Run rcov for rspec"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/pipejump/*_spec.rb', 'spec/pipejump/resources/*_spec.rb']
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

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pipejump-client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
