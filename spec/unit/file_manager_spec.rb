require 'spec_helper'

describe BlueprintsBoy::FileManager do
  let :manager do
    BlueprintsBoy::Manager.new
  end

  describe "initialize" do
    it "should read file into manager" do
      described_class.new(ROOT.join('spec/support/manager_fixture.rb').to_s, manager)
      manager.blueprints[:test].should be_instance_of(BlueprintsBoy::Blueprint)
    end
  end

  describe "blueprint" do
    subject do
      described_class.new(ROOT.join('spec/support/empty_file.rb').to_s, manager)
    end

    it "should add new blueprint" do
      subject.blueprint(:blueprint1) {}
      manager.blueprints[:blueprint1].should be_instance_of(BlueprintsBoy::Blueprint)
    end

    it "should delegate method missing to blueprint" do
      subject.some_blueprint {}
      manager.blueprints[:some_blueprint].should be_instance_of(BlueprintsBoy::Blueprint)
    end
  end
end
