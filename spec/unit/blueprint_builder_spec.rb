require 'spec_helper'

describe BlueprintsBoy::BlueprintBuilder do
  subject(:builder) { described_class.new(blueprint1, env, strategy, options) }
  let(:strategy) { :create }
  let(:options) { {} }

  describe '#initialize' do
    context 'not existing strategy' do
      let(:strategy) { :not_existing_strategy }

      it { expect { subject }.to raise_error(BlueprintsBoy::StrategyNotFound, 'Blueprint :blueprint1 does not define strategy :not_existing_strategy') }
    end
  end

  describe '#build' do
    subject do
      super().build
      env.blueprint1
    end

    it 'builds blueprint' do
      subject.should eq(mock1)
    end

    it 'does not replace existing method' do
      env.set :blueprint1, :correct
      subject.should eq(:correct)
    end

    describe 'blueprint returning name' do
      let(:blueprint1) { create_blueprint(:blueprint1) { |name:| name } }

      it 'allows checking name' do
        subject.should eq(:blueprint1)
      end
    end

    context 'blueprint returning options' do
      let(:blueprint1) { create_blueprint(:blueprint1) { |options:| options } }
      let(:options) { {attr: 'value'} }

      it 'allows checking options' do
        subject.should eq(attr: 'value')
      end
    end

    context 'blueprint returning attributes' do
      let(:blueprint1) do
        create_blueprint(:blueprint1).tap do |blueprint|
          blueprint.attributes = {attr1: 'value1', attr2: 'value2', normalize: dsl.blueprint2}
        end
      end
      let(:options) { {attr2: 'v2', attr3: 'v3'} }
      let(:strategy) { :attributes }

      it 'allows checking normalized attributes with merged options' do
        BlueprintsBoy.manager.blueprints.set blueprint2
        BlueprintsBoy.manager.setup(env)
        subject.should eq(attr1: 'value1', attr2: 'v2', attr3: 'v3', normalize: mock2)
      end
    end

    context 'blueprint using factory' do
      let(:blueprint1) do
        create_blueprint(:blueprint1).tap do |blueprint|
          blueprint.factory_class = Array
        end
      end
      let(:options) { {size: 3} }

      it 'uses factory when building blueprint' do
        BlueprintsBoy.factories.add(Array, :create) { |factory:, attributes:| factory.new(attributes[:size]) }
        subject.should eq(Array.new(3))
      end
    end
  end
end
