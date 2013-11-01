require "bundler/gem_tasks"

require 'rspec/core/rake_task'
spec_namespace = namespace :spec do |ns|
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end
  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = "integration/rspec/rspec_spec.rb"
  end

  [31, 32, 40].each do |version|
    RSpec::Core::RakeTask.new("active_record_#{version}") do |t|
      ENV['BUNDLE_GEMFILE'] = "gemfiles/ar#{version}.gemfile"
      t.pattern = "integration/active_record/active_record_spec.rb"
    end
    RSpec::Core::RakeTask.new("active_record_#{version}_truncation") do |t|
      ENV['BUNDLE_GEMFILE'] = "gemfiles/ar#{version}.gemfile"
      t.pattern = "integration/active_record/active_record_truncation_spec.rb"
    end
  end

  [2, 3].each do |version|
    RSpec::Core::RakeTask.new("mongoid_#{version}") do |t|
      ENV['BUNDLE_GEMFILE'] = "gemfiles/mongoid#{version}.gemfile"
      t.pattern = "integration/mongoid/mongoid_spec.rb"
    end
  end
end

namespace :prepare do
  desc "Prepare database schema for active record"
  task :active_record do
    require_relative 'integration/active_record/setup'
    ActiveRecord::Schema.define(:version => 0) do
      create_table :fruits, :force => true do |t|
        t.string :species
        t.integer :size
        t.belongs_to :parent
      end
    end
  end
end

desc 'Run all specs'
task :spec do
  spec_namespace.tasks.each do |task|
    puts "Running #{task.name}"
    task.invoke
    puts "\n\n"
  end
end

task :default => :spec
