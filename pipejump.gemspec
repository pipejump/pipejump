# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pipejump/version"

Gem::Specification.new do |s|
  s.name        = "pipejump"
  s.version     = Pipejump::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marcin Bunsch", "Michal Bugno", "Antek Piechnik"]
  s.email       = %q{marcin@futuresimple.com}
  s.homepage    = "http://futuresimple.com/api"
  s.description = %q{Base API Ruby client}
  s.summary     = %q{Base API Ruby client}

  s.rubyforge_project = "pipejump"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
