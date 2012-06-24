require 'spec_helper'

describe BlueprintsBoy::Blueprint do
  describe "name" do
    it "should return name" do
      blueprint1.name.should == :blueprint1
    end
  end

  describe "build" do
    it "should build blueprint" do
      blueprint1.build(env)
      env.blueprint1.should == mock1
    end

    it "should not replace existing method" do
      env.set :blueprint1, :correct
      blueprint1.build(env)
      env.blueprint1.should == :correct
    end
  end

  describe "depends_on" do
    it "should return blueprint" do
      blueprint1.depends_on(:blueprint2).should equal(blueprint1)
    end

    it "should allow setting dependencies" do
      blueprint1.depends_on(:blueprint2)
      blueprint1.context.dependencies.should == [:blueprint2]
    end

    it "should allow getting dependencies" do
      blueprint = described_class.new(empty_context, :blueprint) { dependencies }.depends_on(:blueprint2)
      blueprint.build(env)
      env.blueprint.should == [:blueprint2]
    end

    it "should set return values of all dependent blueprints" do
      blueprint1.build(env)
      blueprint2.build(env)
      empty_context.blueprint(:blueprint3).depends_on(:blueprint1, :blueprint2).build(env)
      env.blueprint3.should == [mock1, mock2]
    end
  end

  describe "attributes & options" do
    it "should allow creating blueprint with attributes" do
      blueprint = described_class.new(empty_context, :blueprint, attr: 'value')
      blueprint.context.attrs.should == {attr: 'value'}
    end

    it "should adding attributes to blueprint later" do
      blueprint = described_class.new(empty_context, :blueprint).attributes(attr: 'value')
      blueprint.context.attrs.should == {attr: 'value'}
    end

    it "should allow passing options" do
      blueprint = described_class.new(empty_context, :blueprint) { options }
      blueprint.build(env, attr: 'value')
      env.blueprint.should == {attr: 'value'}
    end

    it "should allow using attributes with merged options in blueprint" do
      blueprint = described_class.new(empty_context, :blueprint, attr1: 'value1', attr2: 'value2') { attributes }
      blueprint.build(env, attr2: 'v2', attr3: 'v3')
      env.blueprint.should == {attr1: 'value1', attr2: 'v2', attr3: 'v3'}
    end

    it "should not overwrite options and attributes methods" do
      def env.options
        :options
      end

      def env.attributes
        :attributes
      end

      blueprint1.build(env, attr: 'value')
      env.options.should == :options
      env.attributes.should == :attributes
    end

    it "should not try to remove options and attributes methods if they're not defined by singleton class" do
      mod = Module.new do
        def options
          :options
        end

        def attributes
          :attributes
        end
      end

      env_class = Class.new { include mod }
      env = create_env(env_class)

      blueprint1.build(env, attr: 'value')
      env.options.should == :options
      env.attributes.should == :attributes
    end

    it "should normalize options and attributes" do
      pending
      blueprint1
      env.instance_variable_set(:@value, 2)
      blueprint2 { [options, attributes] }.attributes(:attr => Blueprints::Dependency.new(:blueprint))
      options, attributes = blueprint2.build(env, :options => {:attr2 => lambda { @value + 2 }, :attr3 => :value})

      options.should == {:attr2 => 4, :attr3 => :value}
      attributes.should == {:attr => mock1, :attr2 => 4, :attr3 => :value}
    end
  end
end
