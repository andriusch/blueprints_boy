require 'rspec'
require 'blueprints_boy'

ROOT = Pathname.new('../../').expand_path(__FILE__)

require_relative 'support/fixtures'

RSpec.configure do |config|
  config.include Fixtures

  config.after do
    BlueprintsBoy.instance_eval do
      @manager = nil
      @config = nil
      @factories = nil
    end
  end

  config.expect_with :rspec do |c|
    c.syntax = :should, :expect
  end
  config.mock_with :rspec do |c|
    c.syntax = :should, :expect
  end
end
