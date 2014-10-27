module BlueprintsBoy::RSpecHelper
  def build(*args)
    before do
      build(*args)
    end
  end
end

RSpec.configure do |config|
  config.include BlueprintsBoy::Helper
  config.extend BlueprintsBoy::RSpecHelper

  config.before do
    BlueprintsBoy.manager.setup(self)
  end

  config.after do
    BlueprintsBoy.manager.teardown
  end
end if RSpec.respond_to?(:configure) # Otherwise db:seed might crash
