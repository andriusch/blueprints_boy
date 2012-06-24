module BlueprintsBoy
  class Context
    attr_accessor :dependencies, :attrs

    def initialize(file_name, manager)
      @file_name = file_name
      @manager = manager
      @dependencies = []
      @attrs = {}
      instance_eval(File.read(file_name), file_name)
    end

    def depends_on(*dependencies, &block)
      chain(dependencies, nil, &block)
    end

    def attributes(attributes, &block)
      chain(nil, attributes, &block)
    end

    def chain(dependencies, attributes, &block)
      dup.tap do |context|
        context.dependencies |= dependencies if dependencies
        context.attrs.merge!(attributes) if attributes
        context.instance_eval(&block) if block
      end
    end

    def blueprint(*args, &block)
      @manager.add(Blueprint.new(self, *args, &block))
    end
  end
end
