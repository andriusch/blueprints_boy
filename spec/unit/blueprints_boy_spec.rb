require 'spec_helper'

describe BlueprintsBoy do
  it 'returns manager' do
    expect(BlueprintsBoy.manager).to be_instance_of(BlueprintsBoy::Manager)
  end

  it 'returns configuration' do
    expect(BlueprintsBoy.config).to be_instance_of(BlueprintsBoy::Configuration)
  end

  it 'returns factories' do
    expect(BlueprintsBoy.factories).to be_instance_of(BlueprintsBoy::Factories)
  end
end
