require 'spec_helper'

describe BlueprintsBoy::Manager do
  describe "add" do
    it "should add blueprint" do
      subject.add(blueprint1)
      subject.blueprints.should == {:blueprint1 => blueprint1}
    end
  end

  describe "build" do
    it "should build blueprint" do
      subject.add(blueprint1)
      subject.build(env, :blueprint1)
      env.blueprint1.should == mock1
    end

    it "should raise error if blueprint is not found" do
      expect {
        subject.build(env, :blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end
  end
end
