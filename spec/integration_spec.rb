require 'spec_helper'

BlueprintsBoy.enable do |config|
  config.root = ROOT
end

describe 'blueprints boy' do
  describe "set" do
    it "should allow setting methods directly" do
      set :apple, 'apple'
      apple.should == 'apple'
    end

    it "should auto set variable" do
      autoset :apple, 'apple'
      apple.should == 'apple'
    end

    it "should not auto set variable if it's already set" do
      set :variable, :correct
      autoset :variable, :incorrect
      variable.should == :correct
    end

    it "should allow reaching fixtures through fixtures method" do
      set :apple, 'apple'
      fixtures(:apple).should == 'apple'
    end
  end

  it "should allow building blueprint" do
    build :apple
    apple.should be_instance_of(Fruit)
    apple.name.should == 'apple'
  end
end
