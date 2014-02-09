require 'spec_helper'

describe BlueprintsBoy::Registry do
  let :names do
    [:mock1, :mock2]
  end

  subject do
    described_class.new(names, nil)
  end

  describe "built" do
    it "should initialize built with empty set" do
      subject.built.should == Set.new
    end

    it "should inherit built from parent" do
      subject.built.add :blueprint1
      child = described_class.new(names, subject)
      child.built.should == Set.new([:blueprint1])
    end
  end

  describe "store/restore" do
    it "should return {} by default" do
      subject.restore.should == {}
    end

    it "should restore results of blueprints" do
      subject.store mock1: mock1, mock2: mock2
      subject.restore.should == {mock1: mock1, mock2: mock2}
    end

    it "should revert changes to restored objects" do
      subject.store mock1: mock1, mock2: mock2
      mock1 << ' has failed us'
      subject.restore[:mock1].should == 'mock1'
    end

    it "should restore parent objects too" do
      child = described_class.new([], subject)
      subject.store mock1: mock1
      child.store mock2: mock2
      child.restore.should == {mock1: mock1, mock2: mock2}
    end
  end
end
