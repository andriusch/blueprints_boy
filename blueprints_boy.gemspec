# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blueprints_boy/version"

Gem::Specification.new do |s|
  s.name = "blueprints_boy"
  s.version = BlueprintsBoy::VERSION
  s.authors = ["Andrius Chamentauskas"]
  s.email = ["andrius.chamentauskas@gmail.com"]
  s.homepage = "http://andriusch.github.io/blueprints_boy/"
  s.summary = %q{The ultimate solution to managing test data.}
  s.description = %q{The ultimate DRY and fast solution to managing any kind of test data. Based on Blueprints.}

  s.rubyforge_project = "blueprints_boy"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'appraisal'
  s.add_runtime_dependency "activesupport", ">= 3.0.0"
  s.add_runtime_dependency "database_cleaner"
end
