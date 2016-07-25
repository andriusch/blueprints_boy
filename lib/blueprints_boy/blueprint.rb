class BlueprintsBoy::Blueprint
  Data = Struct.new(:name, :options, :attributes, :factory)
  attr_reader :name, :context

  def initialize(context, name, attrs = {}, &block)
    @context = context
    @name = name.to_sym
    @strategies = {
        create: block,
        attributes: proc { |attributes:| attributes }
    }
    attributes(attrs)
  end

  def build(environment, strategy, options = {})
    data = Data.new(@name, options, normalized_attributes(environment).merge(options), @context.factory_class)
    block = @strategies[strategy]
    block ||= BlueprintsBoy.factories[@context.factory_class, strategy] if @context.factory_class
    if block
      environment.autoset(@name, eval_block(environment, data, &block))
    else
      raise BlueprintsBoy::StrategyNotFound, "Blueprint #{@name.inspect} does not define strategy #{strategy.inspect}"
    end
  end

  %i[depends_on attributes factory].each do |method|
    define_method(method) do |*args, &block|
      @context.public_send(method, *args)
      self
    end
  end

  def blueprint(strategy, &block)
    @strategies[strategy] = block
  end

  private

  def eval_block(environment, data, &block)
    required = block.parameters.select { |key, _| key == :keyreq }.map { |_, name| [name, data.send(name)] }.to_h
    environment.instance_exec(**required, &block)
  end

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
end
