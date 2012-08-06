module BlueprintsBoy
  class Context
    attr_accessor :dependencies, :attrs, :block

    def initialize(file_name, manager)
      @file_name = file_name
      @manager = manager
      @dependencies = []
      @attrs = {}
      instance_eval(File.read(file_name), file_name)
    end

    def depends_on(*dependencies, &block)
      chain(dependencies, nil, nil, &block)
    end

    def attributes(attributes, &block)
      chain(nil, attributes, nil, &block)
    end

    def factory(factory_class, &block)
      chain(nil, nil, factory_class, &block)
    end

    def chain(dependencies, attributes, factory_class, &block)
      dup.tap do |context|
        context.dependencies |= dependencies if dependencies
        context.attrs.merge!(attributes) if attributes
        context.block = proc { instance_exec(factory_class, &BlueprintsBoy.factories[factory_class]) } if factory_class
        context.instance_eval(&block) if block
      end
    end

    def blueprint(*args, &block)
      @manager.add(Blueprint.new(self, *args, &block))
    end
  end
end
