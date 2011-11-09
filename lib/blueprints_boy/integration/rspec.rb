RSpec.configure do |config|
  config.include BlueprintsBoy::Helper

  config.after do
    BlueprintsBoy.manager.teardown
  end
end
