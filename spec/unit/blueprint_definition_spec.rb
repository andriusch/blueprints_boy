require 'spec_helper'

describe BlueprintsBoy::Blueprint do
  describe '#initialize' do
    specify do
      subject.name.should be_nil
      subject.dependencies.should eq([]).and be_frozen
      subject.attributes.should eq({}).and be_frozen
      subject.factory_class.should be_nil
      subject.strategies.should match(attributes: instance_of(Proc)).and be_frozen
    end
  end
end
