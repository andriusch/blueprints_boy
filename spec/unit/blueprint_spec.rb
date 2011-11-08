require 'spec_helper'

describe BlueprintsBoy::Blueprint do
  describe "name" do
    it "should return name" do
      blueprint1.name.should == :blueprint1
    end
  end
end
