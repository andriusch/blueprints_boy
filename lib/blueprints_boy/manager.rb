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
      result = parse_names(names).collect do |name, build_options|
        build_blueprint(environment, name, build_options)
        environment.blueprint_data(name)
      end
      result.size > 1 ? result : result.first
    end

    def setup(environment)
      environment.instance_variable_set(:@_blueprint_data, {})
      DatabaseCleaner.start
    rescue DatabaseCleaner::NoORMDetected
      # ignored
    end

    def teardown
      @built = Set.new
      DatabaseCleaner.clean
    rescue DatabaseCleaner::NoORMDetected
      # ignored
    end

    private

    def build_blueprint(environment, name, options)
      unless @built.include?(name)
        @built << name
        blueprint = find(name)
        build environment, blueprint.context.dependencies
        blueprint.build(environment, options || {})
      end
    end

    def parse_names(names)
      names_with_options = names.extract_options!
      names.push *names_with_options
    end
  end
end
