require 'spec_helper'

describe BlueprintsBoy::FileManager do
  describe "initialize" do
    it "should read file into manager" do
      manager = BlueprintsBoy::Manager.new
      described_class.new(ROOT.join('spec/support/manager_fixture.rb').to_s, manager)
      manager.blueprints[:test].should be_instance_of(BlueprintsBoy::Blueprint)
    end
  end
end
