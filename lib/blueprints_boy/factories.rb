module BlueprintsBoy
  class Factories
    def initialize
      @factories = {}
    end

    def add(factory_class, &block)
      @factories[factory_class] = block
    end

    def [](factory_class)
      klass = factory_class
      klass = klass.superclass until @factories.key?(klass) or klass.nil?
      @factories[klass] or raise FactoryNotFound, "Factory for #{factory_class} can't be located"
    end
  end
end
