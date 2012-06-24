RSpec.configure do |config|
  config.include BlueprintsBoy::Helper

  config.before do
    BlueprintsBoy.manager.setup(self)
  end

  config.after do
    BlueprintsBoy.manager.teardown
  end
end
