module BlueprintsBoy
  class Manager
    attr_reader :blueprints

    def initialize
      @blueprints = {}
    end

    def add(blueprint)
      @blueprints[blueprint.name] = blueprint
    end

    def build(environment, names)
      names.each do |name|
        blueprint = @blueprints[name]
        raise BlueprintNotFound, "Blueprint :#{name} cannot be found" unless blueprint
        blueprint.build(environment)
      end
    end
  end
end
