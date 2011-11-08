require 'active_support/dependencies/autoload'
require "blueprints_boy/version"

module BlueprintsBoy
  extend ActiveSupport::Autoload

  autoload :BlueprintNotFound, 'blueprints_boy/errors'

  autoload :Configuration
  autoload :Helper
  autoload :FileManager
  autoload :Manager
  autoload :Blueprint

  def self.enable
    yield config
    require 'blueprints_boy/integration/rspec'
    prepare
  end

  def self.prepare
    read_files
  end

  def self.read_files
    config.filenames.each do |pattern|
      Dir[config.root.join(pattern)].each do |file_name|
        FileManager.new(file_name, manager) if File.file?(file_name)
      end
    end
  end

  def self.manager
    @manager ||= Manager.new
  end

  def self.config
    @config ||= Configuration.new
  end
end
