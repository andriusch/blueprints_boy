require 'rspec'
require 'blueprints_boy'

ROOT = Pathname.new('../../').expand_path(__FILE__)

require ROOT.join('spec/support/fixtures')
require ROOT.join('spec/support/models')

RSpec.configure do |config|
  config.include Fixtures
end
