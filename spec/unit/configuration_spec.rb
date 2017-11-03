require 'spec_helper'

describe BlueprintsBoy::Configuration do
  it 'should have filename with default value' do
    subject.filenames.should eq(%w[blueprints.rb blueprints/*.rb spec/blueprints.rb spec/blueprints/*.rb test/blueprints.rb test/blueprints/*.rb].collect { |f| Pathname.new(f) })
  end

  it 'should have correct attribute values' do
    subject.global.should eq([])
    subject.transactions.should be_truthy
    subject.root.should eq(Pathname.pwd)
    subject.cleaner.should be_a(BlueprintsBoy::Cleaner)
  end

  it "should use Rails root for root if it's defined" do
    module Rails
      def self.root
        Pathname.new('rails/root')
      end
    end
    subject.root.should eq(Pathname.new('rails/root'))
    Object.send(:remove_const, :Rails)
  end

  it 'should set root to pathname' do
    subject.root = 'root'
    subject.root.should eq(Pathname.new('root'))
  end

  it 'should automatically set filename to array of path names' do
    subject.filenames = 'my_file.rb'
    subject.filenames.should eq([Pathname.new('my_file.rb')])
  end

  it 'should set global to array of global blueprints' do
    subject.global.should eq([])
    subject.global = :cherry
    subject.global.should eq([:cherry])
  end
end
