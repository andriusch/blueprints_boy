require 'unit_spec_helper'

describe BlueprintsBoy do
  it "should return manager" do
    BlueprintsBoy.manager.should be_instance_of(BlueprintsBoy::Manager)
  end

  it "should return configuration" do
    BlueprintsBoy.config.should be_instance_of(BlueprintsBoy::Configuration)
  end
end
