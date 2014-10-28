require 'active_support/dependencies/autoload'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/reverse_merge'
require 'database_cleaner'
require 'blueprints_boy/version'
require 'blueprints_boy/railtie' if defined?(Rails)

module BlueprintsBoy
  extend ActiveSupport::Autoload

  autoload :BlueprintNotFound, 'blueprints_boy/errors'
  autoload :FactoryNotFound, 'blueprints_boy/errors'
  autoload :StrategyNotFound, 'blueprints_boy/errors'

  autoload :Configuration
  autoload :Helper
  autoload :Context
  autoload :Manager
  autoload :Factories
  autoload :Blueprint
  autoload :Dependency
  autoload :Registry

  def self.enable
    yield config if block_given?
    require 'blueprints_boy/integration/minitest' if defined?(MiniTest)
    require 'blueprints_boy/integration/rspec' if defined?(RSpec)
    require 'blueprints_boy/integration/cucumber' if defined?(Cucumber)
    require 'blueprints_boy/integration/active_record' if defined?(ActiveRecord)
    require 'blueprints_boy/integration/mongoid' if defined?(Mongoid)
    prepare
    manager.push_registry(config.global)
  end

  def self.prepare
    read_files
    DatabaseCleaner.clean_with(:truncation)
  rescue DatabaseCleaner::NoORMDetected
    # ignored
  end

  def self.read_files
    config.filenames.each do |pattern|
      Dir[config.root.join(pattern)].each do |file_name|
        Context.new(file_name) { |blueprint| manager.add(blueprint) } if File.file?(file_name)
      end
    end
  end

  def self.manager
    @manager ||= Manager.new
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.factories
    @factories ||= Factories.new
  end
end
