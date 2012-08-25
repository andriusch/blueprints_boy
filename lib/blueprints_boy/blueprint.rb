class BlueprintsBoy::Blueprint
  Data = Struct.new(:options, :attributes, :factory)
  attr_reader :name, :context

  def initialize(context, name, attrs = {}, &block)
    @context = context
    @name = name.to_sym
    @strategies = {
        create: block,
        attributes: proc { |data| data.attributes }
    }
    attributes(attrs)
  end

  def build(environment, *args)
    options = args.extract_options!
    strategy = args.shift || :create

    data = Data.new(options, normalized_attributes(environment).merge(options), @context.factory_class)
    block = @strategies[strategy]
    block ||= BlueprintsBoy.factories[@context.factory_class, strategy] if @context.factory_class
    if block
      environment.autoset(@name, environment.instance_exec(data, &block))
    else
      raise BlueprintsBoy::StrategyNotFound, "Blueprint #{@name.inspect} does not define strategy #{strategy.inspect}"
    end
  end

  def depends_on(*dependencies)
    update_context dependencies, nil, nil
  end

  def attributes(attributes)
    update_context nil, attributes, nil
  end

  def factory(factory_class)
    update_context nil, nil, factory_class
  end

  def blueprint(strategy, &block)
    @strategies[strategy] = block
  end

  private

  def normalized_attributes(environment)
    @context.attrs.each_with_object({}) do |(key, value), normalized|
      normalized[key] = case value
                        when BlueprintsBoy::Dependency
                          environment.instance_eval(&value)
                        else
                          value
                        end
    end
  end

  def update_context(dependencies, attributes, factory_class)
    @context = @context.chain(dependencies, attributes, factory_class)
    self
  end
end
