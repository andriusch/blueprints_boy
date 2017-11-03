# frozen_string_literal: true
class BlueprintsBoy::Dependency < BasicObject
  def initialize(name, *args)
    @name = name
    @options = args.extract_options!
    @blueprint_name = args.first || @name
    @registry = []
  end

  def to_proc
    name, options, registry, blueprint_name = @name, @options, @registry, @blueprint_name
    ::Proc.new do
      build blueprint_name => options
      registry.inject(blueprint_data(name)) do |value, (method, args, block)|
        value.send(method, *args, &block)
      end
    end
  end

  def method_missing(method, *args, &block)
    @registry << [method, args, block]
    self
  end

  def respond_to_missing?(*)
    true
  end
end
