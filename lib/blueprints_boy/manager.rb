module BlueprintsBoy
  class Manager
    attr_reader :blueprints, :built

    def initialize
      @before_test, @after_test = [], []
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
      parse_names(names).each do |name, build_options|
        unless @built.include?(name)
          @built << name
          blueprint = find(name)
          build environment, blueprint.context.dependencies
          blueprint.build(environment, build_options || {})
        end
      end
    end

    def setup(environment)
      environment.instance_variable_set(:@_blueprint_results, {})
      @before_test.each { |block| block.call }
    end

    def teardown
      @built = Set.new
      @after_test.each { |block| block.call }
    end

    def before_test(&block)
      @before_test << block
    end

    def after_test(&block)
      @after_test << block
    end

    private

    def parse_names(names)
      names_with_options = names.extract_options!
      names.push *names_with_options
    end
  end
end
