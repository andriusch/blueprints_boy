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
    before do
      BlueprintsBoy.instance_variable_set(:@manager, manager)
      manager.add blueprint1
      manager.add blueprint2
    end

    it "should allow building blueprint" do
      env.build :blueprint1
      env.blueprint1.should == mock1
    end

    it "should allow building several blueprints" do
      env.build :blueprint1, :blueprint2
      env.blueprint1.should == mock1
      env.blueprint2.should == mock2
    end
  end
end
