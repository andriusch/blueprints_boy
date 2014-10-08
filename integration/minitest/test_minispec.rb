require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
  config.global = :global_cherry
end

describe BlueprintsBoy do
  describe "build" do
    it "allows building blueprint" do
      build :apple
      apple.must_equal 'apple'
    end

    it "should not allow to reach blueprints from previous specs" do
      blueprint_data(:apple).must_be_nil
    end

    it "allows building same blueprint in another spec" do
      build :apple
      apple.must_equal 'apple'
    end
  end

  describe "class level set" do
    build :apple

    it "should build blueprints in before filter" do
      apple.must_equal 'apple'
    end
  end

  describe "global" do
    it "should build global blueprints" do
      global_cherry.must_equal 'cherry'
    end
  end
end
