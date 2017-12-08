require 'spec_helper'

describe BlueprintsBoy::DSL do
  subject do
    described_class.new(blueprints)
  end

  describe '.from_file' do
    it 'reads file and callback for each blueprint' do
      described_class.from_file(ROOT.join('spec/support/manager_fixture.rb').to_s, blueprints)
      blueprints[:test].name.should eq(:test)
    end
  end

  describe '#blueprint' do
    it 'adds new blueprint' do
      subject.blueprint(:blueprint1, foo: 'bar', &empty_proc)
      blueprint = blueprints[:blueprint1]
      blueprint.should be_instance_of(BlueprintsBoy::Blueprint)
      blueprint.name.should eq(:blueprint1)
      blueprint.attributes.should eq(foo: 'bar')
      blueprint.strategies.should match(create: empty_proc, attributes: instance_of(Proc))
    end

    it 'sets definition' do
      blueprint = subject.depends_on(:blueprint2).blueprint(:blueprint1) {}
      blueprint.definition.should be_instance_of(BlueprintsBoy::Blueprint)
      blueprint.definition.dependencies.should eq([:blueprint2])
    end

    it 'updates blueprint with new definition' do
      subject.blueprint(:blueprint1) {}.depends_on(:blueprint2)
      blueprint = blueprints[:blueprint1]
      blueprint.dependencies.should eq([:blueprint2])
    end
  end

  describe '#depends_on' do
    it 'creates new chain with dependencies set' do
      chain = subject.depends_on(:blueprint, :blueprint2)
      chain.should be_instance_of(BlueprintsBoy::DSL)
      chain.should_not equal(subject)
      chain.definition.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'allows chaining dependencies' do
      chain = subject.depends_on(:blueprint).depends_on(:blueprint2)
      chain.definition.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'merges dependencies' do
      chain = subject.depends_on(:blueprint, :blueprint2).depends_on(:blueprint2, :blueprint3)
      chain.definition.dependencies.should eq([:blueprint, :blueprint2, :blueprint3])
    end

    it 'allows using block form to chain dependencies' do
      chain = nil
      subject.depends_on(:blueprint) do
        chain = depends_on(:blueprint2)
      end
      chain.definition.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'does not modify original dependencies' do
      subject.depends_on(:blueprint)
      subject.definition.dependencies.should eq([])
    end
  end

  describe '#attributes' do
    it 'creates new chain with attributes set' do
      chain = subject.attributes(attr: 'val')
      chain.should be_instance_of(BlueprintsBoy::DSL)
      chain.should_not equal(subject)
      chain.definition.attributes.should eq(attr: 'val')
    end

    it 'allows chaining attributes using block form' do
      chain = nil
      subject.attributes(attr1: 'val1', attr2: 'val2') do
        chain = attributes(attr2: 'v2', attr3: 'v3')
      end
      chain.definition.attributes.should eq(attr1: 'val1', attr2: 'v2', attr3: 'v3')
    end

    it 'does not modify original attributes' do
      subject.attributes(attr: 'val')
      subject.definition.attributes.should eq({})
    end
  end

  describe '#factory' do
    it 'should create new chain with block' do
      chain = subject.factory(Integer)
      chain.definition.factory_class.should eq(Integer)
    end

    it 'should allow chaining after factory' do
      chain = subject.factory(Integer).attributes(attr: 'value')
      chain.definition.factory_class.should eq(Integer)
    end
  end

  describe '#strategy' do
    it 'creates new chain with strategy added' do
      chain = subject.strategy(:update, empty_proc)
      chain.should be_instance_of(BlueprintsBoy::DSL)
      chain.should_not equal(subject)
      chain.definition.strategies.should match(attributes: instance_of(Proc), update: empty_proc)
    end

    it 'allows chaining strategies' do
      proc = empty_proc
      chain = nil
      subject.strategy(:update, proc) do
        chain = strategy(:new, proc)
      end
      chain.definition.strategies.should match(attributes: instance_of(Proc), update: proc, new: proc)
    end

    it 'does not modify original strategies' do
      subject.strategy(:update, empty_proc)
      subject.definition.strategies.should match(attributes: instance_of(Proc))
    end
  end

  describe '#method_missing' do
    it 'should allow dependencies in attributes' do
      dependency = subject.blueprint1
      dependency.should be_a(BlueprintsBoy::Dependency)
    end

    it 'should pass blueprint_name and options' do
      dependency = subject.blueprint1(:blueprint_name, option: 'value')
      dependency.instance_eval do
        @name.should eq(:blueprint1)
        @blueprint_name.should eq(:blueprint_name)
        @options.should eq(option: 'value')
      end
    end
  end

  describe 'group' do
    before do
      blueprints.set blueprint1
      blueprints.set blueprint2
      manager.setup env
    end

    it 'should allow grouping blueprints' do
      subject.group(:my_group => [:blueprint1, :blueprint2])
      manager.build(env, [:my_group])
      env.my_group.should eq([mock1, mock2])
    end

    it 'should allow multiple groups' do
      blueprints.set blueprint3
      subject.group(:group1 => [:blueprint1, :blueprint2], :group2 => [:blueprint2, :blueprint3])
      manager.build(env, [:group2])
      env.group2.should eq([mock2, mock3])
    end
  end
end
