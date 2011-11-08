require 'spec_helper'

BlueprintsBoy.enable do |config|
  config.root = ROOT
end

describe 'blueprints boy' do
  it "should allow setting methods directly" do
    set :apple, 'apple'
    apple.should == 'apple'
  end

  it "should allow building blueprint" do
    build :apple
    apple.should be_instance_of(Fruit)
    apple.name.should == 'apple'
  end
end
