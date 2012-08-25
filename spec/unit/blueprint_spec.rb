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

    it "should use normalized attributes when building" do
      BlueprintsBoy.manager.add blueprint1
      blueprint = described_class.new(empty_context, :blueprint, attr: empty_context.blueprint1) { |data| data.attributes }
      blueprint.build(env)
      env.blueprint.should == {attr: mock1}
    end
  end

  describe "strategies" do
    it "should allow having multiple strategies" do
      blueprint1.blueprint(:options) { |data| data.options }
      blueprint1.build(env, :options, option: 'val')
      env.blueprint1.should == {option: 'val'}
    end

    it "should have attributes strategy" do
      blueprint1.attributes(attr: 'val')
      blueprint1.build(env, :attributes)
      env.blueprint1.should == {attr: 'val'}
    end

    it "should raise error if blueprint doesn't define strategy" do
      expect {
        blueprint1.build(env, :not_existing_strategy)
      }.to raise_error(BlueprintsBoy::StrategyNotFound, 'Blueprint :blueprint1 does not define strategy :not_existing_strategy')
    end
  end

  describe "factory" do
    it "should use factory when building blueprint" do
      BlueprintsBoy.factories.add(Array, :create) { |data| data.factory.new(data.attributes[:size]) }
      blueprint = create_blueprint('blueprint1').factory(Array)
      blueprint.build(env, size: 3)
      env.blueprint1.should == Array.new(3)
    end
  end
end
