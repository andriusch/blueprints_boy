require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'blueprints_boy'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
  config.global = :global_cherry
end

describe BlueprintsBoy do
  describe 'build' do
    it 'allows building blueprint' do
      build :apple
      _(apple).must_equal 'apple'
    end

    it 'disallows to reach blueprints from previous specs' do
      _(blueprint_data(:apple)).must_be_nil
    end

    it 'allows building same blueprint in another spec' do
      build :apple
      _(apple).must_equal 'apple'
    end
  end

  describe 'class level set' do
    build :apple

    it 'builds blueprints in before filter' do
      _(apple).must_equal 'apple'
    end
  end

  describe 'global' do
    it 'builds global blueprints' do
      _(global_cherry).must_equal 'cherry'
    end
  end

  describe 'overriding blueprint' do
    describe 'with overridden blueprint' do
      blueprint :orange, name: 'red orange'

      it 'auto builds orange when method is called' do
        _(orange).must_equal 'red orange'
      end
    end

    describe 'without overridden blueprint' do
      it 'uses original attributes by default' do
        build :orange
        _(orange).must_equal 'orange'
      end
    end
  end
end
