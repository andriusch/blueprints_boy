require 'bundler/setup'
require 'rspec'
require 'blueprints_boy'
require_relative '../shared'

BlueprintsBoy.enable do |config|
  config.root = File.dirname(__FILE__)
  config.global = :global_cherry
end

describe 'rspec integration' do
  describe 'set' do
    it 'allows setting methods directly' do
      set :apple, 'apple'
      apple.should eq('apple')
    end

    it 'returns value that is set' do
      set(:apple, 'apple').should eq('apple')
    end

    it 'auto sets variable' do
      autoset :apple, 'apple'
      apple.should eq('apple')
    end

    it "does not auto set variable if it's already set" do
      set :variable, :correct
      autoset :variable, :incorrect
      variable.should eq(:correct)
    end

    it 'still auto sets variable in blueprint_data even if environment defines method with same name' do
      def self.variable
      end

      autoset :variable, :correct
      variable.should be_nil
      blueprint_data(:variable).should eq(:correct)
    end

    it 'still returns new value if variable is already set' do
      set :variable, :correct
      autoset(:variable, :incorrect).should eq(:incorrect)
    end

    it 'allows reaching fixtures through fixtures method' do
      set :apple, 'apple'
      blueprint_data(:apple).should eq('apple')
    end
  end

  describe 'build' do
    it 'allows building blueprint' do
      build :apple
      apple.should eq('apple')
    end

    it 'allows building several blueprints' do
      build :apple, :orange
      apple.should eq('apple')
      orange.should eq('orange')
    end

    it 'does not allow to reach blueprints from previous specs' do
      blueprint_data(:apple).should be_nil
    end
  end

  describe 'build with' do
    it 'allows building using different strategy' do
      build_with :attributes, :orange
      orange.should eq(name: 'orange')
    end
  end

  describe 'build!' do
    it 'allows building blueprint twice' do
      orange1 = build! :orange
      orange2 = build! :orange => {name: 'not apple'}
      orange1.should eq('orange')
      orange2.should eq('not apple')
    end
  end

  describe 'build_new' do
    it 'builds blueprint using :new strategy' do
      build_new :orange
      orange.should eq('new orange')
    end
  end

  describe 'build_attributes' do
    it 'returns attributes for building' do
      build_attributes :orange => {size: 2}
      orange.should eq(name: 'orange', size: 2)
    end
  end

  describe 'class level set' do
    build :apple, orange: {name: 'mandarin orange'}

    it 'builds blueprints in before filter' do
      apple.should eq('apple')
      orange.should eq('mandarin orange')
    end
  end

  describe 'global' do
    it 'builds global blueprints' do
      global_cherry.should eq('cherry')
    end
  end

  describe 'overriding blueprint' do
    context 'with overridden blueprint' do
      before { blueprint :orange, name: 'red orange' }

      it 'builds orange with new attributes' do
        build :orange
        expect(orange).to eq('red orange')
      end

      it 'auto builds orange when method is called' do
        expect(orange).to eq('red orange')
      end

      context 'with overridden blueprint in class scope' do
        blueprint :orange, name: 'mandarin orange'

        it 'builds orange with new attributes' do
          expect(orange).to eq('mandarin orange')
        end
      end

      context 'with multiple blueprint overrides' do
        blueprint :apple do
          'red apple'
        end

        it 'builds both with new attributes' do
          expect(apple).to eq('red apple')
          expect(orange).to eq('red orange')
        end
      end
    end

    context 'without overridden blueprint' do
      it 'uses original attributes by default' do
        build :orange
        expect(orange).to eq('orange')
      end
    end
  end
end
