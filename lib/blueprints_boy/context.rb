module BlueprintsBoy
  class Context
    attr_reader :dependencies, :attrs, :factory_class

    def initialize
      @dependencies = []
      @attrs = {}
      @factory_class = nil
    end

    def depends_on(*dependencies)
      @dependencies |= dependencies
    end

    def attributes(**attributes)
      @attrs = @attrs.merge(attributes)
    end

    def factory(factory_class)
      @factory_class = factory_class
    end
  end
end
