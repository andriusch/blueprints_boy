require 'rspec'
require 'blueprints_boy'

ROOT = Pathname.new('../../').expand_path(__FILE__)

require_relative 'support/fixtures'
require_relative 'support/models'

RSpec.configure do |config|
  config.include Fixtures
end
