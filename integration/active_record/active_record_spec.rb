require_relative 'setup'
require 'rspec'
require 'blueprints_boy'
require_relative '../shared'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe ActiveRecord::Base do
  it "should create record in database" do
    build :apple
    apple.should be_a(ARFruit)
    apple.should be_persisted
    apple.species.should eq('apple')
  end

  it "should clean database before each test" do
    ARFruit.all.should eq([])
  end

  it "should use transactions for cleaning database" do
    ActiveRecord::Base.connection.open_transactions.should eq(1)
  end

  it "should allow building using :new strategy" do
    build_with :new, :apple
    apple.should be_a(ARFruit)
    apple.should be_new_record
    apple.species.should eq('apple')
  end

  it "should allow updating built blueprint" do
    build :apple
    build :apple => {species: 'orange'}
    apple.reload.species.should eq('orange')
  end
end
