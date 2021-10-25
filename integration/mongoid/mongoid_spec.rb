require 'rspec'
require 'mongoid'
require_relative '../shared'

class MongoidFruit
  include Mongoid::Document

  field :species
  field :size, :type => Integer

  attr_protected :species if Mongoid::VERSION.to_i < 4
end

Mongoid.configure.logger = Logger.new(File.expand_path('debug.log', __dir__))
if Mongoid.configure.respond_to?(:connect_to)
  Mongoid.configure.connect_to 'blueprints_boy'
else
  Mongoid.configure.from_hash 'database' => 'blueprints_boy'
end

require 'blueprints_boy'
BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe Mongoid do
  it 'creates record in database' do
    build :apple
    expect(apple).to be_a(MongoidFruit)
    expect(apple).to be_persisted
    expect(apple.species).to eq('apple')
  end

  it 'cleans database before each test' do
    expect(MongoidFruit.all.to_a).to eq([])
  end

  it 'allows building using :new strategy' do
    build_with :new, :apple
    expect(apple).to be_a(MongoidFruit)
    expect(apple).to be_new_record
    expect(apple.species).to eq('apple')
  end

  it 'allows updating built blueprint' do
    build :apple
    build :apple => {species: 'orange'}
    expect(apple.reload.species).to eq('orange')
  end
end
