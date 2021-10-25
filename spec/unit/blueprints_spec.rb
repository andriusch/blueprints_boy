require 'spec_helper'

describe BlueprintsBoy::Blueprints do
  describe 'find' do
    it 'finds set blueprint' do
      subject.set(blueprint1)
      expect(subject.find(:blueprint1)).to equal(blueprint1)
      expect(subject[:blueprint1]).to equal(blueprint1)
    end

    it 'raises error if blueprint is not found' do
      expect {
        subject.find(:blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end

    it 'finds blueprint from parent' do
      child = described_class.new(subject)
      subject.set(blueprint1)
      expect(child.find(:blueprint1)).to equal(blueprint1)
    end
  end
end
