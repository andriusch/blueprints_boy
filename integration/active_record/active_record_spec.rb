require_relative 'setup'
require 'rspec'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
end

describe ActiveRecord::Base do
  it "should create record in database" do
    build :apple
    apple.should be_a(ARFruit)
    apple.should be_persisted
    apple.species.should == 'apple'
  end

  it "should clean database before each test" do
    ARFruit.all.should == []
  end

  it "should use transactions for cleaning database" do
    ActiveRecord::Base.connection.open_transactions.should == 1
  end
end
