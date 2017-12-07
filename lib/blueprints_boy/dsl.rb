# frozen_string_literal: true
module BlueprintsBoy
  class DSL
    attr_reader :definition

    def self.from_file(file_name, manager)
      new(manager).instance_eval(File.read(file_name), file_name)
    end

    def initialize(manager, definition = Blueprint.new)
      @manager = manager
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
      chain(block) { |definition| definition.strategies = definition.strategies.merge(name => strategy) }
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

    def dependency(name, *args, &block)
      BlueprintsBoy::Dependency.new(name, *args, &block)
    end

    alias method_missing dependency

    protected

    def chain(block)
      definition = @definition.dup
      yield definition

      @manager.blueprints.set(definition) if definition.name

      self.class.new(@manager, definition).tap do |definition_chain|
        definition_chain.instance_eval(&block) if block
      end
    end
  end
end
