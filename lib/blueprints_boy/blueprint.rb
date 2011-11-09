class BlueprintsBoy::Blueprint
  attr_reader :name

  def initialize(name, &block)
    @name = name
    @block = block
    @built = false
  end

  def build(environment)
    return if @built
    @built = true
    result = environment.instance_eval(&@block)
    environment.autoset(@name, result)
  end

  def built?
    @built
  end
end
