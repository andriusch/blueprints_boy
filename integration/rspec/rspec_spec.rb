require 'bundler/setup'
require 'rspec'
require 'blueprints_boy'
require_relative '../shared'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
  config.global = :global_cherry
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

    it "should still return new value if variable is already set" do
      set :variable, :correct
      autoset(:variable, :incorrect).should == :incorrect
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

  describe "build with" do
    it "should allow building using different strategy" do
      build_with :attributes, :orange
      orange.should == {name: 'orange'}
    end
  end

  describe "build!" do
    it "allows building blueprint twice" do
      orange1 = build! :orange
      orange2 = build! :orange => {name: 'not apple'}
      orange1.should == 'orange'
      orange2.should == 'not apple'
    end
  end

  describe "build_new" do
    it "builds blueprint using :new strategy" do
      build_new :orange
      orange.should == 'new orange'
    end
  end

  describe "build_attributes" do
    it "returns attributes for building" do
      build_attributes :orange => {size: 2}
      orange.should == {name: 'orange', size: 2}
    end
  end

  describe "class level set" do
    build :apple

    it "should build blueprints in before filter" do
      apple.should == 'apple'
    end
  end

  describe "global" do
    it "should build global blueprints" do
      global_cherry.should == 'cherry'
    end
  end
end
