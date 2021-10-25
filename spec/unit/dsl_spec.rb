require 'spec_helper'

describe BlueprintsBoy::DSL do
  subject do
    described_class.new(blueprints)
  end

  describe '.from_file' do
    it 'reads file and callback for each blueprint' do
      described_class.from_file(ROOT.join('spec/support/manager_fixture.rb').to_s, blueprints)
      expect(blueprints[:test].name).to eq(:test)
    end
  end

  describe '#blueprint' do
    it 'adds new blueprint' do
      subject.blueprint(:blueprint1, foo: 'bar', &empty_proc)
      blueprint = blueprints[:blueprint1]
      expect(blueprint).to be_instance_of(BlueprintsBoy::Blueprint)
      expect(blueprint.name).to eq(:blueprint1)
      expect(blueprint.attributes).to eq(foo: 'bar')
      expect(blueprint.strategies).to match(create: empty_proc, attributes: instance_of(Proc))
    end

    it 'sets definition' do
      blueprint = subject.depends_on(:blueprint2).blueprint(:blueprint1) {}
      expect(blueprint.definition).to be_instance_of(BlueprintsBoy::Blueprint)
      expect(blueprint.definition.dependencies).to eq([:blueprint2])
    end

    it 'updates blueprint with new definition' do
      subject.blueprint(:blueprint1) {}.depends_on(:blueprint2)
      blueprint = blueprints[:blueprint1]
      expect(blueprint.dependencies).to eq([:blueprint2])
    end
  end

  describe '#depends_on' do
    it 'creates new chain with dependencies set' do
      chain = subject.depends_on(:blueprint, :blueprint2)
      expect(chain).to be_instance_of(BlueprintsBoy::DSL)
      expect(chain).not_to equal(subject)
      expect(chain.definition.dependencies).to eq(%i[blueprint blueprint2])
    end

    it 'allows chaining dependencies' do
      chain = subject.depends_on(:blueprint).depends_on(:blueprint2)
      expect(chain.definition.dependencies).to eq(%i[blueprint blueprint2])
    end

    it 'merges dependencies' do
      chain = subject.depends_on(:blueprint, :blueprint2).depends_on(:blueprint2, :blueprint3)
      expect(chain.definition.dependencies).to eq(%i[blueprint blueprint2 blueprint3])
    end

    it 'allows using block form to chain dependencies' do
      chain = nil
      subject.depends_on(:blueprint) do
        chain = depends_on(:blueprint2)
      end
      expect(chain.definition.dependencies).to eq(%i[blueprint blueprint2])
    end

    it 'does not modify original dependencies' do
      subject.depends_on(:blueprint)
      expect(subject.definition.dependencies).to eq([])
    end
  end

  describe '#attributes' do
    it 'creates new chain with attributes set' do
      chain = subject.attributes(attr: 'val')
      expect(chain).to be_instance_of(BlueprintsBoy::DSL)
      expect(chain).not_to equal(subject)
      expect(chain.definition.attributes).to eq(attr: 'val')
    end

    it 'allows chaining attributes using block form' do
      chain = nil
      subject.attributes(attr1: 'val1', attr2: 'val2') do
        chain = attributes(attr2: 'v2', attr3: 'v3')
      end
      expect(chain.definition.attributes).to eq(attr1: 'val1', attr2: 'v2', attr3: 'v3')
    end

    it 'does not modify original attributes' do
      subject.attributes(attr: 'val')
      expect(subject.definition.attributes).to eq({})
    end
  end

  describe '#factory' do
    it 'creates new chain with block' do
      chain = subject.factory(Integer)
      expect(chain.definition.factory_class).to eq(Integer)
    end

    it 'allows chaining after factory' do
      chain = subject.factory(Integer).attributes(attr: 'value')
      expect(chain.definition.factory_class).to eq(Integer)
    end
  end

  describe '#strategy' do
    it 'creates new chain with strategy added' do
      chain = subject.strategy(:update, empty_proc)
      expect(chain).to be_instance_of(BlueprintsBoy::DSL)
      expect(chain).not_to equal(subject)
      expect(chain.definition.strategies).to match(attributes: instance_of(Proc), update: empty_proc)
    end

    it 'allows chaining strategies' do
      proc = empty_proc
      chain = nil
      subject.strategy(:update, proc) do
        chain = strategy(:new, proc)
      end
      expect(chain.definition.strategies).to match(attributes: instance_of(Proc), update: proc, new: proc)
    end

    it 'does not replace strategy with nil' do
      chain = subject.strategy(:attributes, nil)
      expect(chain.definition.strategies).to match(attributes: instance_of(Proc))
    end

    it 'does not modify original strategies' do
      subject.strategy(:update, empty_proc)
      expect(subject.definition.strategies).to match(attributes: instance_of(Proc))
    end
  end

  describe '#method_missing' do
    it 'allows dependencies in attributes' do
      dependency = subject.blueprint1
      expect(dependency).to be_a(BlueprintsBoy::Dependency)
    end

    it 'passs blueprint_name and options' do
      dependency = subject.blueprint1(:blueprint_name, option: 'value')
      dependency.instance_eval do
        expect(@name).to eq(:blueprint1)
        expect(@blueprint_name).to eq(:blueprint_name)
        expect(@options).to eq(option: 'value')
      end
    end
  end

  describe 'group' do
    before do
      blueprints.set blueprint1
      blueprints.set blueprint2
      manager.setup env
    end

    it 'allows grouping blueprints' do
      subject.group(:my_group => %i[blueprint1 blueprint2])
      manager.build(env, [:my_group])
      expect(env.my_group).to eq([mock1, mock2])
    end

    it 'allows multiple groups' do
      blueprints.set blueprint3
      subject.group(:group1 => %i[blueprint1 blueprint2], :group2 => %i[blueprint2 blueprint3])
      manager.build(env, [:group2])
      expect(env.group2).to eq([mock2, mock3])
    end
  end
end
