require 'spec_helper'

describe BlueprintsBoy::Context do
  let :manager do
    BlueprintsBoy::Manager.new
  end

  describe "initialize" do
    it "should read file and callback for each blueprint" do
      blueprints = []
      described_class.new(ROOT.join('spec/support/manager_fixture.rb').to_s) { |blueprint| blueprints << blueprint }
      blueprints.should have(1).element
      blueprints.first.name.should == :test
    end
  end

  describe "blueprint" do
    it "should add new blueprint" do
      blueprint = empty_context.blueprint(:blueprint1) {}
      blueprint.should be_instance_of(BlueprintsBoy::Blueprint)
      blueprint.name.should == :blueprint1
    end

    it "should set context" do
      blueprint = empty_context.depends_on(:blueprint2).blueprint(:blueprint1) {}
      blueprint.context.should be_instance_of(BlueprintsBoy::Context)
      blueprint.context.dependencies.should == [:blueprint2]
    end
  end

  describe "depends_on" do
    it "should set dependencies to empty array" do
      empty_context.dependencies.should == []
    end

    it "should create new context with dependencies set" do
      context = empty_context.depends_on(:blueprint, :blueprint2)
      context.should be_instance_of(BlueprintsBoy::Context)
      context.should_not equal(empty_context)
      context.dependencies.should == [:blueprint, :blueprint2]
    end

    it "should allow chaining dependencies" do
      context = empty_context.depends_on(:blueprint).depends_on(:blueprint2)
      context.dependencies.should == [:blueprint, :blueprint2]
    end

    it "should allow using block form to chain dependencies" do
      context = nil
      empty_context.depends_on(:blueprint) do
        context = depends_on(:blueprint2)
      end
      context.dependencies.should == [:blueprint, :blueprint2]
    end

    it "should only keep uniq dependencies" do
      context = empty_context.depends_on(:blueprint).depends_on(:blueprint)
      context.dependencies.should == [:blueprint]
    end

    it "should not modify original dependencies" do
      empty_context.depends_on(:blueprint)
      empty_context.dependencies.should == []
    end
  end

  describe "attributes" do
    it "should set attributes to empty hash" do
      empty_context.attrs.should == {}
    end

    it "should create new context with attributes set" do
      context = empty_context.attributes(attr: 'val')
      context.should be_instance_of(BlueprintsBoy::Context)
      context.should_not equal(empty_context)
      context.attrs.should == {attr: 'val'}
    end

    it "should allow chaining attributes using block form" do
      context = nil
      empty_context.attributes(attr1: 'val1', attr2: 'val2') do
        context = attributes(attr2: 'v2', attr3: 'v3')
      end
      context.attrs.should == {attr1: 'val1', attr2: 'v2', attr3: 'v3'}
    end

    it "should not modify original attributes" do
      empty_context.attributes(attr: 'val')
      empty_context.attrs.should == {}
    end
  end

  describe "factories" do
    it "should set block to nil" do
      empty_context.factory_class.should be_nil
    end

    it "should create new context with block" do
      context = empty_context.factory(Fixnum)
      context.factory_class.should == Fixnum
    end

    it "should allow chaining after factory" do
      context = empty_context.factory(Fixnum).attributes(attr: 'value')
      context.factory_class.should == Fixnum
    end
  end

  describe "creating dependencies" do
    it "should allow dependencies in attributes" do
      dependency = empty_context.blueprint1
      (BlueprintsBoy::Dependency === dependency).should be_true
    end

    it "should pass blueprint_name and options" do
      dependency = empty_context.blueprint1(:blueprint_name, option: 'value')
      dependency.instance_eval do
        @name.should == :blueprint1
        @blueprint_name.should == :blueprint_name
        @options.should == {option: 'value'}
      end
    end
  end

  describe "group" do
    before do
      BlueprintsBoy.manager.add blueprint1
      BlueprintsBoy.manager.add blueprint2
      BlueprintsBoy.manager.setup env
    end

    it "should allow grouping blueprints" do
      group, = empty_context.group(:blueprints => [:blueprint1, :blueprint2])
      group.build(env)
      env.blueprints.should == [mock1, mock2]
    end

    it "should allow multiple groups" do
      BlueprintsBoy.manager.add blueprint3
      _, group2 = empty_context.group(:group1 => [:blueprint1, :blueprint2], :group2 => [:blueprint2, :blueprint3])
      group2.build(env)
      env.group2.should == [mock2, mock3]
    end
  end
end
