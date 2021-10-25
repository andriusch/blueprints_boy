# frozen_string_literal: true

class BlueprintsBoy::BlueprintBuilder
  def initialize(blueprint, environment, strategy, options)
    @environment = environment

    @name = blueprint.name
    @factory = blueprint.factory_class
    @options = options
    @attributes = normalize_attributes(blueprint).merge(options)

    @strategy = blueprint.strategies[strategy]
    @strategy ||= BlueprintsBoy.factories[blueprint.factory_class, strategy] if blueprint.factory_class
    fail BlueprintsBoy::StrategyNotFound, "Blueprint #{@name.inspect} does not define strategy #{strategy.inspect}" unless @strategy
  end

  def build
    required = @strategy.parameters.select { |key, _| key == :keyreq }
                        .map { |_, name| [name, instance_variable_get("@#{name}")] }.to_h
    @environment.autoset @name, @environment.instance_exec(**required, &@strategy)
  end

  private

  def normalize_attributes(blueprint)
    blueprint.attributes.transform_values do |value|
      case value
      when BlueprintsBoy::Dependency
        @environment.instance_eval(&value)
      else
        value
      end
    end
  end
end
