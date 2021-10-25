require 'spec_helper'

describe BlueprintsBoy::Configuration do
  it 'has filename with default value' do
    expect(subject.filenames).to eq(%w[blueprints.rb blueprints/*.rb spec/blueprints.rb spec/blueprints/*.rb test/blueprints.rb test/blueprints/*.rb].collect { |f| Pathname.new(f) })
  end

  it 'has correct attribute values' do
    expect(subject.global).to eq([])
    expect(subject.transactions).to be_truthy
    expect(subject.root).to eq(Pathname.pwd)
    expect(subject.cleaner).to be_a(BlueprintsBoy::Cleaner)
  end

  it "uses Rails root for root if it's defined" do
    module Rails
      def self.root
        Pathname.new('rails/root')
      end
    end
    expect(subject.root).to eq(Pathname.new('rails/root'))
    Object.send(:remove_const, :Rails)
  end

  it 'sets root to pathname' do
    subject.root = 'root'
    expect(subject.root).to eq(Pathname.new('root'))
  end

  it 'automatically sets filename to array of path names' do
    subject.filenames = 'my_file.rb'
    expect(subject.filenames).to eq([Pathname.new('my_file.rb')])
  end

  it 'sets global to array of global blueprints' do
    expect(subject.global).to eq([])
    subject.global = :cherry
    expect(subject.global).to eq([:cherry])
  end
end
