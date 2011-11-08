require 'spec_helper'

describe BlueprintsBoy::Blueprint do
  describe "name" do
    it "should return name" do
      blueprint1.name.should == :blueprint1
    end
  end

  describe "build" do
    it "should build blueprint" do
      blueprint1.build(env)
      env.blueprint1.should == mock1
    end

    it "should not replace existing method" do
      env.set :blueprint1, :correct
      blueprint1.build(env)
      env.blueprint1.should == :correct
    end
  end
end
