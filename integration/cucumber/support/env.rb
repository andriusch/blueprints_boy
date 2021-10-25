require 'bundler/setup'
require 'cucumber'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.expand_path('../../rspec', __dir__)
  config.global = :global_cherry
end
