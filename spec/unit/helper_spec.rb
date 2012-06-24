require 'unit_spec_helper'

BlueprintsBoy.enable do |config|
  config.root = ROOT
end

describe BlueprintsBoy::Helper do
  describe "set" do
    it "should allow setting methods directly" do
      env.set :apple, 'apple'
      env.apple.should == 'apple'
    end

    it "should auto set variable" do
      env.autoset :apple, 'apple'
      env.apple.should == 'apple'
    end

    it "should not auto set variable if it's already set" do
      env.set :variable, :correct
      env.autoset :variable, :incorrect
      env.variable.should == :correct
    end

    it "should allow reaching fixtures through fixtures method" do
      env.set :apple, 'apple'
      env.fixtures(:apple).should == 'apple'
    end
  end

  describe "build" do
    it "should allow building blueprint" do
      env.build :apple
      env.apple.should be_instance_of(Fruit)
      env.apple.name.should == 'apple'
    end

    it "should allow building several blueprints" do
      env.build :apple, :orange
      env.apple.name.should == 'apple'
      env.orange.name.should == 'orange'
    end
  end
end
