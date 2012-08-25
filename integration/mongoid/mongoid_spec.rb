require 'rspec'
require 'mongoid'

class MongoidFruit
  include Mongoid::Document

  field :species
  field :size, :type => Integer

  attr_protected :species
end

Mongoid.configure do |config|
  config.connect_to 'blueprints_test'
end

require 'blueprints_boy'
BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe Mongoid do
  it "should create record in database" do
    build :apple
    apple.should be_a(MongoidFruit)
    apple.should be_persisted
    apple.species.should == 'apple'
  end

  it "should clean database before each test" do
    MongoidFruit.all.to_a.should == []
  end

  it "should allow building using :new strategy" do
    build_with :new, :apple
    apple.should be_a(MongoidFruit)
    apple.should be_new_record
    apple.species.should == 'apple'
  end
end
