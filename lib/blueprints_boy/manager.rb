module BlueprintsBoy
  class Manager
    attr_reader :blueprints, :built

    def initialize
      @blueprints = {}
      teardown
    end

    def add(blueprint)
      @blueprints[blueprint.name] = blueprint
    end

    def find(name)
      @blueprints[name] or raise BlueprintNotFound, "Blueprint :#{name} cannot be found"
    end
    alias_method :[], :find

    def build(environment, names)
      names.each do |name|
        unless @built.include?(name)
          @built << name
          blueprint = find(name)
          build environment, blueprint.context.dependencies
          blueprint.build(environment)
        end
      end
    end

    def teardown
      @built = Set.new
    end
  end
end
