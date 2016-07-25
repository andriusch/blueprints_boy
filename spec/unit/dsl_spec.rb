require 'spec_helper'

describe BlueprintsBoy::DSL do
  subject do
    described_class.new(manager)
  end

  describe '.from_file' do
    it 'reads file and callback for each blueprint' do
      described_class.from_file(ROOT.join('spec/support/manager_fixture.rb').to_s, manager)
      manager.blueprints.keys.should eq([:test])
      manager.blueprints[:test].name.should eq(:test)
    end
  end

  describe '#blueprint' do
    it 'adds new blueprint' do
      blueprint = subject.blueprint(:blueprint1) {}
      blueprint.should be_instance_of(BlueprintsBoy::Blueprint)
      blueprint.name.should eq(:blueprint1)
    end

    it 'sets context' do
      blueprint = subject.depends_on(:blueprint2).blueprint(:blueprint1) {}
      blueprint.context.should be_instance_of(BlueprintsBoy::Context)
      blueprint.context.dependencies.should eq([:blueprint2])
    end
  end

  describe '#depends_on' do
    it 'creates new chain with dependencies set' do
      chain = subject.depends_on(:blueprint, :blueprint2)
      chain.should be_instance_of(BlueprintsBoy::DSL)
      chain.should_not equal(subject)
      chain.context.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'allows chaining dependencies' do
      chain = subject.depends_on(:blueprint).depends_on(:blueprint2)
      chain.context.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'allows using block form to chain dependencies' do
      chain = nil
      subject.depends_on(:blueprint) do
        chain = depends_on(:blueprint2)
      end
      chain.context.dependencies.should eq([:blueprint, :blueprint2])
    end

    it 'does not modify original dependencies' do
      subject.depends_on(:blueprint)
      subject.context.dependencies.should eq([])
    end
  end

  describe '#attributes' do
    it 'creates new chain with attributes set' do
      chain = subject.attributes(attr: 'val')
      chain.should be_instance_of(BlueprintsBoy::DSL)
      chain.should_not equal(subject)
      chain.context.attrs.should eq(attr: 'val')
    end

    it 'allows chaining attributes using block form' do
      chain = nil
      subject.attributes(attr1: 'val1', attr2: 'val2') do
        chain = attributes(attr2: 'v2', attr3: 'v3')
      end
      chain.context.attrs.should eq(attr1: 'val1', attr2: 'v2', attr3: 'v3')
    end

    it 'does not modify original attributes' do
      subject.attributes(attr: 'val')
      subject.context.attrs.should eq({})
    end
  end

  describe '#factory' do
    it 'should create new chain with block' do
      chain = subject.factory(Fixnum)
      chain.context.factory_class.should eq(Fixnum)
    end

    it 'should allow chaining after factory' do
      chain = subject.factory(Fixnum).attributes(attr: 'value')
      chain.context.factory_class.should eq(Fixnum)
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
      manager.add blueprint1
      manager.add blueprint2
      manager.setup env
    end

    it 'should allow grouping blueprints' do
      subject.group(:blueprints => [:blueprint1, :blueprint2])
      manager.build(env, [:blueprints])
      env.blueprints.should eq([mock1, mock2])
    end

    it 'should allow multiple groups' do
      manager.add blueprint3
      subject.group(:group1 => [:blueprint1, :blueprint2], :group2 => [:blueprint2, :blueprint3])
      manager.build(env, [:group2])
      env.group2.should eq([mock2, mock3])
    end
  end
end
