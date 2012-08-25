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

    it "should allow building blueprint with no block" do
      blueprint = create_blueprint(:blueprint1)
      expect {
        blueprint.build(env)
      }.not_to raise_error
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
      blueprint = described_class.new(empty_context, :blueprint) { |data| data.options }
      blueprint.build(env, attr: 'value')
      env.blueprint.should == {attr: 'value'}
    end

    it "should allow using attributes with merged options in blueprint" do
      blueprint = described_class.new(empty_context, :blueprint, attr1: 'value1', attr2: 'value2') { |data| data.attributes }
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
  end

  describe "normalized attributes" do
    before do
      BlueprintsBoy.manager.add blueprint1
      blueprint1.build(env)
    end

    subject do
      create_blueprint(:subject) { |data| data.attributes }
    end

    it "should return normalized attributes" do
      subject.attributes(attr: empty_context.blueprint1)
      subject.normalized_attributes(env).should == {attr: mock1}
    end

    it "should use normalized attributes when building" do
      subject.attributes(attr: empty_context.blueprint1)
      subject.build(env)
      env.subject.should == {attr: mock1}
    end
  end

  describe "factory" do
    it "should use factory when building blueprint" do
      BlueprintsBoy.factories.add(Array) { |data| data.factory.new(data.attributes[:size]) }
      blueprint = create_blueprint('blueprint1').factory(Array)
      blueprint.build(env, size: 3)
      env.blueprint1.should == Array.new(3)
    end
  end
end
