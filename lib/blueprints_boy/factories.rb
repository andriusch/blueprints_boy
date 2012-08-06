module BlueprintsBoy
  class Factories
    def initialize
      @factories = {}
    end

    def add(factory_class, &block)
      @factories[factory_class] = block
    end

    def [](factory_class)
      factory_class.ancestors.each do |ancestor|
        return @factories[ancestor] if @factories.key?(ancestor)
      end
      raise FactoryNotFound, "Factory for #{factory_class} can't be located"
    end
  end
end
