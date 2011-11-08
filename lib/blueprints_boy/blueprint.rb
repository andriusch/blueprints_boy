class BlueprintsBoy::Blueprint
  attr_reader :name

  def initialize(name, &block)
    @name = name
    @block = block
  end

  def build(environment)
    result = environment.instance_eval(&@block)
    environment.set(@name, result)
  end
end
