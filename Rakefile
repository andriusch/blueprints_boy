require "bundler/setup"
require 'appraisal'
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end
  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = "integration/rspec/rspec_spec.rb"
  end

  RSpec::Core::RakeTask.new(:active_record => 'prepare:active_record') do |t|
    t.pattern = "integration/active_record/active_record_spec.rb"
  end
  RSpec::Core::RakeTask.new(:active_record_truncation => 'prepare:active_record') do |t|
    t.pattern = "integration/active_record/active_record_truncation_spec.rb"
  end

  RSpec::Core::RakeTask.new(:mongoid) do |t|
    t.pattern = "integration/mongoid/mongoid_spec.rb"
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
  def find_gem(name)
    Bundler.setup.specs.find { |spec| spec.name == name }
  end

  def run(task)
    puts "Running #{task}"
    Rake::Task[task].invoke
    puts "\n\n"
  end

  if find_gem('activerecord')
    run 'spec:active_record'
    run 'spec:active_record_truncation'
  elsif find_gem('mongoid')
    run 'spec:mongoid'
  else
    run 'spec:rspec'
    run 'spec:unit'
  end
end

task :default => :spec
