require 'spec_helper'

describe BlueprintsBoy::Dependency do
  before do
    blueprints.set blueprint1
    BlueprintsBoy.manager.setup env
  end

  def value(dep)
    env.instance_eval(&dep)
  end

  it 'should allow getting instance variable value' do
    value(described_class.new(:blueprint1)).should eq(mock1)
  end

  it 'should allow getting another instance variable' do
    preset_mock = double
    env.set(:preset_key, preset_mock)
    value(described_class.new(:preset_key, :blueprint1)).should eq(preset_mock)
  end

  it 'should allow passing options for building' do
    blueprints.set(create_blueprint(:options_blueprint) { |options:| options })
    value(described_class.new(:options_blueprint, :option => 'value')).should eq(:option => 'value')
  end

  describe 'missing methods' do
    subject { described_class.new(:blueprint1) }

    it 'should record all missing methods' do
      subject.missing_method
      mock1.should_receive(:missing_method).and_return(mock2)
      value(subject).should eq(mock2)
    end

    it 'should allow chaining methods' do
      subject.missing_method.another_missing_method
      mock1.should_receive(:missing_method).and_return(mock2)
      mock2.should_receive(:another_missing_method).and_return(mock3)
      value(subject).should eq(mock3)
    end

    it 'should remember parameters' do
      subject.missing_method(1, 2)
      mock1.should_receive(:missing_method).with(1, 2).and_return(mock2)
      value(subject).should eq(mock2)
    end

    it 'should remember block' do
      subject.missing_method { |value| value + 2 }
      mock1.should_receive(:missing_method).and_yield(1)
      value(subject).should eq(3)
    end
  end
end
