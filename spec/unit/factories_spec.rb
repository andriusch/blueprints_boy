require_relative '../spec_helper'

describe BlueprintsBoy::Factories do
  describe 'finding' do
    before do
      subject.add(Integer, :create) { 5 }
    end

    it 'should allow defining and finding a factory' do
      factory = subject[Integer, :create]
      factory.should be_instance_of(Proc)
      factory.call.should eq(5)
    end

    it 'should find factory for child class' do
      factory = subject[Integer, :create]
      factory.should be_instance_of(Proc)
      factory.call.should eq(5)
    end

    it "should raise error if factory can't be found" do
      expect {
        subject[Float, :create]
      }.to raise_error(BlueprintsBoy::FactoryNotFound, "Factory for Float can't be located")
    end
  end
end
