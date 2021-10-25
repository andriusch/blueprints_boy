require 'spec_helper'

describe BlueprintsBoy::Registry do
  let :names do
    %i[mock1 mock2]
  end

  subject do
    described_class.new(names, nil)
  end

  describe 'built' do
    it 'initializes built with empty set' do
      expect(subject.built).to eq(Set.new)
    end

    it 'inherits built from parent' do
      subject.built.add :blueprint1
      child = described_class.new(names, subject)
      expect(child.built).to eq(Set.new([:blueprint1]))
    end
  end

  describe 'store/restore' do
    it 'returns {} by default' do
      expect(subject.restore).to eq({})
    end

    it 'restores results of blueprints' do
      subject.store mock1: mock1, mock2: mock2
      expect(subject.restore).to eq(mock1: mock1, mock2: mock2)
    end

    it 'reverts changes to restored objects' do
      subject.store mock1: mock1, mock2: mock2
      mock1 << ' has failed us'
      expect(subject.restore[:mock1]).to eq('mock1')
    end

    it 'restores parent objects too' do
      child = described_class.new([], subject)
      subject.store mock1: mock1
      child.store mock2: mock2
      expect(child.restore).to eq(mock1: mock1, mock2: mock2)
    end
  end
end
