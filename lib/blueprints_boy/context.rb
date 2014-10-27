module BlueprintsBoy
  class Context
    attr_accessor :dependencies, :attrs, :factory_class

    def initialize(file_name, &added_callback)
      @file_name = file_name
      @added_callback = added_callback
      @dependencies = []
      @attrs = {}
      @factory_class = nil
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

    def chain(dependencies, attributes, factory, &block)
      dup.tap do |context|
        context.dependencies |= dependencies if dependencies
        context.attrs = context.attrs.merge(attributes) if attributes
        context.factory_class = factory if factory
        context.instance_eval(&block) if block
      end
    end

    def blueprint(*args, &block)
      Blueprint.new(self, *args, &block).tap do |blueprint|
        @added_callback.call blueprint if @added_callback
      end
    end

    def group(groups)
      groups.collect do |name, children|
        blueprint(name) { build(*children) }
      end
    end

    def dependency(name, *args, &block)
      BlueprintsBoy::Dependency.new(name, *args, &block)
    end

    alias_method :method_missing, :dependency
  end
end
