require "bundler/gem_tasks"

require 'rspec/core/rake_task'
namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
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
