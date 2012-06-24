require 'unit_spec_helper'

describe BlueprintsBoy::Manager do
  describe "add" do
    it "should add blueprint" do
      subject.add(blueprint1)
      subject.blueprints.should == {:blueprint1 => blueprint1}
    end
  end

  describe "find" do
    it "should find added blueprint" do
      subject.add(blueprint1)
      subject.find(:blueprint1).should equal(blueprint1)
      subject[:blueprint1].should equal(blueprint1)
    end

    it "should raise error if blueprint is not found" do
      expect {
        subject.find(:blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end
  end

  describe "build" do
    before do
      subject.add(blueprint1)
    end

    it "should build blueprint" do
      subject.build(env, [:blueprint1])
      env.blueprint1.should == mock1
    end

    it "should add blueprint to build blueprints" do
      subject.build(env, [:blueprint1])
      subject.built.should include(:blueprint1)
    end

    it "should not build same blueprint twice" do
      env.expects(:autoset).once
      subject.build(env, [:blueprint1, :blueprint1])
    end

    it "should build dependencies of blueprint" do
      subject.add blueprint2.depends_on(:blueprint1)
      subject.build env, [:blueprint2]
      subject.built.to_a.should == [:blueprint2, :blueprint1]
    end
  end

  describe "teardown" do
    it "should mark all teardown all blueprints" do
      subject.add(blueprint1)
      subject.build(env, [:blueprint1])
      subject.teardown
      subject.built.should be_empty
    end
  end
end
