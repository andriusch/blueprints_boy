require 'spec_helper'

describe BlueprintsBoy::Blueprints do
  describe 'find' do
    it 'should find set blueprint' do
      subject.set(blueprint1)
      subject.find(:blueprint1).should equal(blueprint1)
      subject[:blueprint1].should equal(blueprint1)
    end

    it 'should raise error if blueprint is not found' do
      expect {
        subject.find(:blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end

    it 'should find blueprint from parent' do
      child = described_class.new(subject)
      subject.set(blueprint1)
      child.find(:blueprint1).should equal(blueprint1)
    end
  end
end
