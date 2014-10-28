require 'bundler/setup'
require 'cucumber'
require 'blueprints_boy'

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
#require 'cucumber/rspec'

BlueprintsBoy.enable do |config|
  config.root = File.expand_path("../../../rspec", __FILE__)
  config.global = :global_cherry
end
