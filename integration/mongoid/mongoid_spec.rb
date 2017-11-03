require 'rspec'
require 'mongoid'
require_relative '../shared'

class MongoidFruit
  include Mongoid::Document

  field :species
  field :size, :type => Integer

  attr_protected :species if Mongoid::VERSION.to_i < 4
end

Mongoid.configure.logger = Logger.new(File.expand_path('../debug.log', __FILE__))
if Mongoid.configure.respond_to?(:connect_to)
  Mongoid.configure.connect_to 'blueprints_test'
else
  Mongoid.configure.from_hash 'database' => 'blueprints_test'
end

require 'blueprints_boy'
BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe Mongoid do
  it 'should create record in database' do
    build :apple
    apple.should be_a(MongoidFruit)
    apple.should be_persisted
    apple.species.should eq('apple')
  end

  it 'should clean database before each test' do
    MongoidFruit.all.to_a.should eq([])
  end

  it 'should allow building using :new strategy' do
    build_with :new, :apple
    apple.should be_a(MongoidFruit)
    apple.should be_new_record
    apple.species.should eq('apple')
  end

  it 'should allow updating built blueprint' do
    build :apple
    build :apple => {species: 'orange'}
    apple.reload.species.should eq('orange')
  end
end
