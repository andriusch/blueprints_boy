require 'spec_helper'

describe BlueprintsBoy::Manager do
  describe "add" do
    it "should add blueprint" do
      subject.add(blueprint1)
      subject.blueprints.should == {:blueprint1 => blueprint1}
    end
  end

  describe "find" do
    it "should find added blueprint" do
      subject.add(blueprint1)
      subject.find(:blueprint1).should equal(blueprint1)
      subject[:blueprint1].should equal(blueprint1)
    end

    it "should raise error if blueprint is not found" do
      expect {
        subject.find(:blueprint_not_existing)
      }.to raise_error(BlueprintsBoy::BlueprintNotFound, 'Blueprint :blueprint_not_existing cannot be found')
    end
  end

  describe "build" do
    before do
      subject.add(blueprint1)
    end

    it "should build blueprint" do
      subject.build(env, [:blueprint1])
      env.blueprint1.should == mock1
    end

    it "should add blueprint to build blueprints" do
      subject.build(env, [:blueprint1])
      subject.built.should include(:blueprint1)
    end

    it "should not build same blueprint twice" do
      env.expects(:autoset).once
      subject.build(env, [:blueprint1, :blueprint1])
    end

    it "should use update strategy if options are present and blueprint is already built" do
      mock1.should_receive(:update)
      blueprint1.blueprint(:update) { blueprint1.update }
      subject.build(env, [:blueprint1, {:blueprint1 => {option: 'value'}}])
    end

    it "should build dependencies of blueprint" do
      subject.add blueprint2.depends_on(:blueprint1)
      subject.build env, [:blueprint2]
      subject.built.to_a.should == [:blueprint2, :blueprint1]
    end

    it "should allow passing options" do
      subject.add(create_blueprint(:options_blueprint) { |data| data.options[:name] })
      subject.build(env, [{:options_blueprint => {name: 'success'}}])
      env.options_blueprint.should == 'success'
    end

    it "should return results" do
      subject.add(blueprint2)
      subject.build(env, [:blueprint1, :blueprint2 => {attr: 'val'}]).should == [mock1, mock2]
    end

    it "should return 1 result if only one blueprint was built" do
      subject.build(env, [:blueprint1]).should == mock1
    end

    it "should return results for already built blueprints" do
      subject.build(env, [:blueprint1])
      subject.build(env, [:blueprint1]).should == mock1
    end

    it "should allow passing strategy" do
      blueprint1.blueprint(:new) { :new_strat }
      subject.build(env, [:blueprint1], strategy: :new)
      env.blueprint1.should == :new_strat
    end
  end

  describe "setup" do
    it "should set @_blueprint_results to {}" do
      subject.setup(env)
      env.instance_variable_get(:@_blueprint_data).should == {}
    end
  end

  describe "teardown" do
    it "should mark all teardown all blueprints" do
      subject.add(blueprint1)
      subject.build(env, [:blueprint1])
      subject.teardown
      subject.built.should be_empty
    end
  end
end
