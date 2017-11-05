require 'spec_helper'

describe BlueprintsBoy::Manager do
  describe 'set' do
    it 'should set blueprint' do
      subject.set(blueprint1)
      subject.blueprints.should eq(:blueprint1 => blueprint1)
    end
  end

  describe 'find' do
    it 'should find seted blueprint' do
      subject.set(blueprint1)
      subject.find(:blueprint1).should equal(blueprint1)
      subject[:blueprint1].should equal(blueprint1)
    end

    it 'should raise error if blueprint is not found' do
      expect {
        subject.find(:blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end
  end

  describe 'build' do
    before do
      subject.set(blueprint1)
      subject.push_registry
    end

    it 'should build blueprint' do
      subject.build(env, [:blueprint1])
      env.blueprint1.should eq(mock1)
    end

    it 'should set blueprint to built blueprints' do
      subject.build(env, [:blueprint1])
      subject.registry.built.should include(:blueprint1)
    end

    it 'should not build same blueprint twice' do
      env.should_receive(:autoset).once
      subject.build(env, [:blueprint1, :blueprint1])
    end

    it 'should use update strategy if options are present and blueprint is already built' do
      mock1.should_receive(:update)
      blueprint1.strategies = blueprint1.strategies.merge(update: proc { blueprint1.update })
      subject.build(env, [:blueprint1, {:blueprint1 => {option: 'value'}}])
    end

    it 'should build dependencies of blueprint' do
      blueprint2.dependencies |= [:blueprint1]
      subject.set blueprint2
      subject.build env, [:blueprint2]
      subject.registry.built.to_a.should eq([:blueprint2, :blueprint1])
    end

    it 'should allow passing options' do
      subject.set(create_blueprint(:options_blueprint) { |options:| options[:name] })
      subject.build(env, [{:options_blueprint => {name: 'success'}}])
      env.options_blueprint.should eq('success')
    end

    it 'should return results' do
      subject.set(blueprint2)
      subject.build(env, [:blueprint1, :blueprint2 => {attr: 'val'}]).should eq([mock1, mock2])
    end

    it 'should return 1 result if only one blueprint was built' do
      subject.build(env, [:blueprint1]).should eq(mock1)
    end

    it 'should return results for already built blueprints' do
      subject.build(env, [:blueprint1])
      subject.build(env, [:blueprint1]).should eq(mock1)
    end

    it 'should allow passing strategy' do
      blueprint1.strategies = blueprint1.strategies.merge(new: proc { :new_strat })
      subject.build(env, [:blueprint1], strategy: :new)
      env.blueprint1.should eq(:new_strat)
    end

    it 'does not overwrite strategy with :update' do
      counter = 0
      blueprint1.strategies = blueprint1.strategies.merge(counter: proc { counter += 1 })
      2.times { subject.build(env, [:blueprint1], strategy: :counter) }
      counter.should eq(2)
    end
  end

  describe 'setup' do
    it 'should set @_blueprint_data to {}' do
      subject.setup(env)
      env.instance_variable_get(:@_blueprint_data).should eq({})
    end

    it 'should restore blueprints from registry to @_blueprint_data' do
      blueprint1
      blueprint2
      subject.set(blueprint1)
      subject.set(blueprint2)

      subject.push_registry([:blueprint1])
      subject.push_registry([:blueprint2])

      subject.setup(env)
      env.instance_variable_get(:@_blueprint_data).should eq(blueprint1: mock1, blueprint2: mock2)
    end
  end

  describe 'teardown' do
    it 'should pop registry' do
      subject.set(blueprint1)
      subject.push_registry
      subject.build(env, [:blueprint1])

      subject.teardown
      subject.registry.should be_nil
    end
  end
end
