require_relative '../spec_helper'

describe BlueprintsBoy::Factories do
  describe 'finding' do
    before do
      subject.add(Integer, :create) { 5 }
    end

    it 'allows defining and finding a factory' do
      factory = subject[Integer, :create]
      expect(factory).to be_instance_of(Proc)
      expect(factory.call).to eq(5)
    end

    it 'finds factory for child class' do
      factory = subject[Integer, :create]
      expect(factory).to be_instance_of(Proc)
      expect(factory.call).to eq(5)
    end

    it "raises error if factory can't be found" do
      expect {
        subject[Float, :create]
      }.to raise_error(BlueprintsBoy::FactoryNotFound, "Factory for Float can't be located")
    end
  end
end
