require_relative 'setup'
require 'rspec'
require 'blueprints_boy'
require_relative '../shared'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe ActiveRecord::Base do
  it 'creates record in database' do
    build :apple
    expect(apple).to be_a(ARFruit)
    expect(apple).to be_persisted
    expect(apple.species).to eq('apple')
  end

  it 'cleans database before each test' do
    expect(ARFruit.all).to eq([])
  end

  it 'uses transactions for cleaning database' do
    expect(ActiveRecord::Base.connection.open_transactions).to eq(1)
  end

  it 'allows building using :new strategy' do
    build_with :new, :apple
    expect(apple).to be_a(ARFruit)
    expect(apple).to be_new_record
    expect(apple.species).to eq('apple')
  end

  it 'allows updating built blueprint' do
    build :apple
    build :apple => {species: 'orange'}
    expect(apple.reload.species).to eq('orange')
  end
end
