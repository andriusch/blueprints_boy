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

  describe "build" do
    it "should allow building blueprint" do
      build :apple
      apple.should be_instance_of(Fruit)
      apple.name.should == 'apple'
    end

    it "should allow building several blueprints" do
      build :apple, :orange
      apple.name.should == 'apple'
      orange.name.should == 'orange'
    end
  end
end
