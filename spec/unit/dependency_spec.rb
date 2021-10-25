require 'spec_helper'

describe BlueprintsBoy::Dependency do
  before do
    blueprints.set blueprint1
    BlueprintsBoy.manager.setup env
  end

  def value(dep)
    env.instance_eval(&dep)
  end

  it 'allows getting instance variable value' do
    expect(value(described_class.new(:blueprint1))).to eq(mock1)
  end

  it 'allows getting another instance variable' do
    preset_mock = double
    env.set(:preset_key, preset_mock)
    expect(value(described_class.new(:preset_key, :blueprint1))).to eq(preset_mock)
  end

  it 'allows passing options for building' do
    blueprints.set(create_blueprint(:options_blueprint) { |options:| options })
    expect(value(described_class.new(:options_blueprint, :option => 'value'))).to eq(:option => 'value')
  end

  describe 'missing methods' do
    subject { described_class.new(:blueprint1) }

    it 'records all missing methods' do
      subject.missing_method
      expect(mock1).to receive(:missing_method).and_return(mock2)
      expect(value(subject)).to eq(mock2)
    end

    it 'allows chaining methods' do
      subject.missing_method.another_missing_method
      expect(mock1).to receive(:missing_method).and_return(mock2)
      expect(mock2).to receive(:another_missing_method).and_return(mock3)
      expect(value(subject)).to eq(mock3)
    end

    it 'remembers parameters' do
      subject.missing_method(1, 2)
      expect(mock1).to receive(:missing_method).with(1, 2).and_return(mock2)
      expect(value(subject)).to eq(mock2)
    end

    it 'remembers block' do
      subject.missing_method { |value| value + 2 }
      expect(mock1).to receive(:missing_method).and_yield(1)
      expect(value(subject)).to eq(3)
    end
  end
end
