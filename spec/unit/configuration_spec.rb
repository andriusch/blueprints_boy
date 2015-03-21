require 'spec_helper'

describe BlueprintsBoy::Configuration do
  it "should have filename with default value" do
    subject.filenames.should == %w{blueprints.rb blueprints/*.rb spec/blueprints.rb spec/blueprints/*.rb test/blueprints.rb test/blueprints/*.rb}.collect do |f|
      Pathname.new(f)
    end
  end

  it "should have correct attribute values" do
    subject.global.should == []
    subject.transactions.should be_truthy
    subject.root.should == Pathname.pwd
  end

  it "should use Rails root for root if it's defined" do
    module Rails
      def self.root
        Pathname.new('rails/root')
      end
    end
    subject.root.should == Pathname.new('rails/root')
    Object.send(:remove_const, :Rails)
  end

  it "should set root to pathname" do
    subject.root = "root"
    subject.root.should == Pathname.new("root")
  end

  it "should automatically set filename to array of path names" do
    subject.filenames = "my_file.rb"
    subject.filenames.should == [Pathname.new("my_file.rb")]
  end

  it "should set global to array of global blueprints" do
    subject.global.should == []
    subject.global = :cherry
    subject.global.should == [:cherry]
  end
end
