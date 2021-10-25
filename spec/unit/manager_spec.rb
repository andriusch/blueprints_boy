require 'spec_helper'

describe BlueprintsBoy::Manager do
  describe 'build' do
    before do
      blueprints.set(blueprint1)
      subject.push_registry(env)
    end

    it 'builds blueprint' do
      subject.build(env, [:blueprint1])
      expect(env.blueprint1).to eq(mock1)
    end

    it 'sets blueprint to built blueprints' do
      subject.build(env, [:blueprint1])
      expect(subject.registry.built).to include(:blueprint1)
    end

    it 'does not build same blueprint twice' do
      expect(env).to receive(:autoset).once
      subject.build(env, [:blueprint1, :blueprint1])
    end

    it 'uses update strategy if options are present and blueprint is already built' do
      expect(mock1).to receive(:update)
      blueprint1.strategies = blueprint1.strategies.merge(update: proc { blueprint1.update })
      subject.build(env, [:blueprint1, {:blueprint1 => {option: 'value'}}])
    end

    it 'builds dependencies of blueprint' do
      blueprint2.dependencies |= [:blueprint1]
      blueprint1.strategies = blueprint1.strategies.merge(new: proc { :new_strat1 })
      blueprint2.strategies = blueprint2.strategies.merge(new: proc { :new_strat2 })
      blueprints.set blueprint2
      subject.build env, [:blueprint2], strategy: :new
      expect(env.blueprint1).to eq(:new_strat1)
    end

    it 'uses same strategy for dependencies' do
      blueprint2.dependencies |= [:blueprint1]
      blueprints.set blueprint2
      subject.build env, [:blueprint2]
      expect(subject.registry.built.to_a).to eq([:blueprint2, :blueprint1])
    end

    it 'allows passing options' do
      blueprints.set(create_blueprint(:options_blueprint) { |options:| options[:name] })
      subject.build(env, [{:options_blueprint => {name: 'success'}}])
      expect(env.options_blueprint).to eq('success')
    end

    it 'returns results' do
      blueprints.set(blueprint2)
      expect(subject.build(env, [:blueprint1, :blueprint2 => {attr: 'val'}])).to eq([mock1, mock2])
    end

    it 'returns 1 result if only one blueprint was built' do
      expect(subject.build(env, [:blueprint1])).to eq(mock1)
    end

    it 'returns results for already built blueprints' do
      subject.build(env, [:blueprint1])
      expect(subject.build(env, [:blueprint1])).to eq(mock1)
    end

    it 'allows passing strategy' do
      blueprint1.strategies = blueprint1.strategies.merge(new: proc { :new_strat })
      subject.build(env, [:blueprint1], strategy: :new)
      expect(env.blueprint1).to eq(:new_strat)
    end

    it 'does not overwrite strategy with :update' do
      counter = 0
      blueprint1.strategies = blueprint1.strategies.merge(counter: proc { counter += 1 })
      2.times { subject.build(env, [:blueprint1], strategy: :counter) }
      expect(counter).to eq(2)
    end
  end

  describe 'setup' do
    it 'sets @_blueprint_data to {}' do
      subject.setup(env)
      expect(env.instance_variable_get(:@_blueprint_data)).to eq({})
    end

    it 'restores blueprints from registry to @_blueprint_data' do
      blueprints.set(blueprint1)
      blueprints.set(blueprint2)

      subject.push_registry(env, [:blueprint1])
      subject.push_registry(env, [:blueprint2])

      subject.setup(env)
      expect(env.instance_variable_get(:@_blueprint_data)).to eq(blueprint1: mock1, blueprint2: mock2)
    end
  end

  describe 'teardown' do
    it 'pops registry' do
      blueprints.set(blueprint1)
      subject.push_registry(env)
      subject.build(env, [:blueprint1])

      subject.teardown
      expect(subject.registry).to be_nil
    end
  end
end
