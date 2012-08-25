require 'rspec'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe 'rspec integration' do
  describe "set" do
    it "should allow setting methods directly" do
      set :apple, 'apple'
      apple.should == 'apple'
    end

    it "should return value that is set" do
      set(:apple, 'apple').should == 'apple'
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

    it "should still autoset variable in blueprint_data even if environment defines method with same name" do
      def self.variable
      end

      autoset :variable, :correct
      variable.should be_nil
      blueprint_data(:variable).should == :correct
    end

    it "should still return original value if variable is already set" do
      set :variable, :correct
      autoset(:variable, :incorrect).should == :correct
    end

    it "should allow reaching fixtures through fixtures method" do
      set :apple, 'apple'
      blueprint_data(:apple).should == 'apple'
    end
  end

  describe "build" do
    it "should allow building blueprint" do
      build :apple
      apple.should == 'apple'
    end

    it "should allow building several blueprints" do
      build :apple, :orange
      apple.should == 'apple'
      orange.should == 'orange'
    end

    it "should not allow to reach blueprints from previous specs" do
      blueprint_data(:apple).should be_nil
    end
  end
end
