# frozen_string_literal: true
module BlueprintsBoy
  class Factories
    def initialize
      @factories = Hash.new { |hash, key| hash[key] = {} }
    end

    def add(factory_class, strategy, &block)
      @factories[factory_class][strategy] = block
    end

    def [](factory_class, strategy)
      factory_class.ancestors.each do |ancestor|
        return @factories[ancestor][strategy] if @factories.key?(ancestor)
      end
      fail FactoryNotFound, "Factory for #{factory_class} can't be located"
    end
  end
end
