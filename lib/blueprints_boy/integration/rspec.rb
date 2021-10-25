# frozen_string_literal: true

module BlueprintsBoy::RSpecMacros
  def build(*args, &block)
    before { build(*args, &block) }
  end

  def blueprint(*args, **options, &block)
    before { blueprint(*args, **options, &block) }
  end
end

if RSpec.respond_to?(:configure) # Otherwise db:seed might crash
  RSpec.configure do |config|
    config.include BlueprintsBoy::Helper
    config.extend BlueprintsBoy::RSpecMacros

    config.before do
      BlueprintsBoy.manager.setup(self)
    end

    config.after do
      BlueprintsBoy.manager.teardown
    end
  end
end
