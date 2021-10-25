require 'spec_helper'

describe BlueprintsBoy::Blueprint do
  describe '#initialize' do
    specify do
      expect(subject.name).to be_nil
      expect(subject.dependencies).to eq([]).and be_frozen
      expect(subject.attributes).to eq({}).and be_frozen
      expect(subject.factory_class).to be_nil
      expect(subject.strategies).to match(attributes: instance_of(Proc)).and be_frozen
    end
  end
end
