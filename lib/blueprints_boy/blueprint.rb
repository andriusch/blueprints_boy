class BlueprintsBoy::Blueprint
  attr_reader :name, :context

  def initialize(context, name, attrs = {}, &block)
    @context = context
    @name = name.to_sym
    @block = block || proc { dependencies.map { |dep| send(dep) } }
    attributes(attrs)
  end

  def build(environment, options = {})
    result = nil
    with_method(environment, :options, options) do
      with_method(environment, :attributes, context.attrs.merge(options)) do
        with_method(environment, :dependencies, context.dependencies) do
          result = environment.instance_eval(&@block)
        end
      end
    end
    environment.autoset(@name, result)
  end

  def depends_on(*dependencies)
    update_context dependencies, nil
  end

  def attributes(attributes)
    update_context nil, attributes
  end

  private

  def update_context(dependencies, attributes)
    @context = @context.chain(dependencies, attributes)
    self
  end

  def with_method(environment, name, value)
    old_method = nil
    environment.singleton_class.class_eval do
      if method_defined?(name)
        old_method = environment.method(name)
        if old_method.owner == self
          remove_method(name)
        else
          old_method = nil
        end
      end
      define_method(name) { value }
    end
    yield
  ensure
    environment.singleton_class.class_eval do
      remove_method(name)
      define_method(name, old_method) if old_method
    end
  end
end
