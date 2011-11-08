# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blueprints_boy/version"

Gem::Specification.new do |s|
  s.name        = "blueprints_boy"
  s.version     = BlueprintsBoy::VERSION
  s.authors     = ["Andrius Chamentauskas"]
  s.email       = ["andrius.chamentauskas@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "blueprints_boy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_runtime_dependency "activesupport", ">= 3.0.0"
end
