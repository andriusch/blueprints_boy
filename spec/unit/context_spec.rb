require 'unit_spec_helper'

describe BlueprintsBoy::Context do
  let :manager do
    BlueprintsBoy::Manager.new
  end

  describe "initialize" do
    it "should read file into manager" do
      described_class.new(ROOT.join('spec/support/manager_fixture.rb').to_s, manager)
      manager.blueprints[:test].should be_instance_of(BlueprintsBoy::Blueprint)
    end
  end

  describe "blueprint" do
    it "should add new blueprint" do
      blueprint = empty_context.blueprint(:blueprint1) {}
      blueprint.should be_instance_of(BlueprintsBoy::Blueprint)
      manager.blueprints[:blueprint1].should equal(blueprint)
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
  end
end
