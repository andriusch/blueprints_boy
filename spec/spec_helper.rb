require 'rspec'
require 'blueprints_boy'
require 'pathname'

ROOT = Pathname.new('../../').expand_path(__FILE__)

require_relative 'support/fixtures'

RSpec.configure do |config|
  config.include Fixtures

  config.after do
    BlueprintsBoy.instance_eval do
      @manager = nil
      @config = nil
      @factories = nil
      @blueprints = nil
    end
  end
end
