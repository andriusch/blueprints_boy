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

    it "should mark blueprint as built" do
      expect {
        blueprint1.build(env)
      }.to change(blueprint1, :built?).from(false).to(true)
    end

    it "should not build blueprint twice" do
      env.expects(:autoset).once
      blueprint1.build(env)
      blueprint1.build(env)
    end
  end

  describe "teardown" do
    it "should mark blueprint as not built" do
      blueprint1.build(env)
      blueprint1.teardown
      blueprint1.should_not be_built
    end
  end
end
