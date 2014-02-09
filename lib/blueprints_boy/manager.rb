module BlueprintsBoy
  class Manager
    attr_reader :blueprints, :registry

    def initialize
      @blueprints = {}
      @registry = nil
    end

    def add(blueprint)
      @blueprints[blueprint.name] = blueprint
    end

    def find(name)
      @blueprints[name] or raise BlueprintNotFound, "Blueprint :#{name} cannot be found"
    end

    alias_method :[], :find

    def build(environment, names, options = {})
      result = parse_names(names).collect do |name, attributes|
        build_blueprint(environment, name, attributes, options)
        environment.blueprint_data(name)
      end
      result.size > 1 ? result : result.first
    end

    def setup(environment)
      prepare_env(environment)
      push_registry
      @registry.restore.each { |name, value| environment.set name, value }

      DatabaseCleaner.start
    rescue DatabaseCleaner::NoORMDetected
      # ignored
    end

    def teardown
      @registry = @registry.parent
      DatabaseCleaner.clean
    rescue DatabaseCleaner::NoORMDetected
      # ignored
    end

    def push_registry(blueprint_names = [])
      @registry = Registry.new(blueprint_names, @registry)

      environment = Object.new
      environment.singleton_class.send(:include, BlueprintsBoy::Helper)
      prepare_env(environment)
      build(environment, @registry.names)
      @registry.store environment.blueprint_data
    end

    private

    def prepare_env(environment)
      environment.instance_variable_set(:@_blueprint_data, {})
    end

    def build_blueprint(environment, name, attributes, options)
      if @registry.built.include?(name)
        if attributes.present?
          options[:strategy] = :update
        else
          return
        end
      end

      @registry.built << name
      blueprint = find(name)
      build environment, blueprint.context.dependencies
      blueprint.build(environment, options[:strategy], attributes || {})
    end

    def parse_names(names)
      names_with_options = names.extract_options!
      names.push *names_with_options
    end
  end
end
