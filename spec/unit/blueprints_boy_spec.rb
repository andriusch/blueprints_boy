require 'spec_helper'

describe BlueprintsBoy do
  it 'should return manager' do
    BlueprintsBoy.manager.should be_instance_of(BlueprintsBoy::Manager)
  end

  it 'should return configuration' do
    BlueprintsBoy.config.should be_instance_of(BlueprintsBoy::Configuration)
  end

  it 'should return factories' do
    BlueprintsBoy.factories.should be_instance_of(BlueprintsBoy::Factories)
  end
end
