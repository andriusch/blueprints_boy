# frozen_string_literal: true
module BlueprintsBoy
  class DSL
    attr_reader :definition

    def self.from_file(file_name, blueprints)
      new(blueprints).instance_eval(File.read(file_name), file_name)
    end

    def initialize(blueprints, definition = Blueprint.new)
      @blueprints = blueprints
      @definition = definition
    end

    def depends_on(*dependencies, &block)
      chain(block) { |definition| definition.dependencies |= dependencies }
    end

    def attributes(**attributes, &block)
      chain(block) { |definition| definition.attributes = definition.attributes.merge(attributes) }
    end

    def factory(factory, &block)
      chain(block) { |definition| definition.factory_class = factory }
    end

    def strategy(name, strategy, &block)
      chain(block) { |definition| definition.strategies = definition.strategies.merge(name => strategy) if strategy }
    end

    def blueprint(name, **attributes, &block)
      attributes(**attributes).strategy(:create, block).chain(nil) do |definition|
        definition.name = name.to_sym
      end
    end

    def group(groups)
      groups.collect do |name, children|
        depends_on(*children).blueprint(name) { blueprint_data.values_at(*children) }
      end
    end

    def dependency(name, *args, **options, &block)
      BlueprintsBoy::Dependency.new(name, *args, **options, &block)
    end

    alias method_missing dependency

    protected

    def chain(block)
      definition = @definition.dup
      yield definition

      @blueprints.set(definition) if definition.name

      self.class.new(@blueprints, definition).tap do |definition_chain|
        definition_chain.instance_eval(&block) if block
      end
    end
  end
end
