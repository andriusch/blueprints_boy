# frozen_string_literal: true
World BlueprintsBoy::Helper

Before do
  BlueprintsBoy.manager.setup(self)
end

After do
  BlueprintsBoy.manager.teardown
end
