# frozen_string_literal: true
module BlueprintsBoy
  module Helper
    def set(name, value)
      instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      def self.#{name}
        @_blueprint_data[:#{name}]
      end
      RUBY
      @_blueprint_data[name] = value
    end

    def autoset(name, value)
      if respond_to?(name)
        @_blueprint_data[name] ||= value
      else
        set(name, value)
      end
      value
    end

    def blueprint_data(name = nil)
      if name
        @_blueprint_data[name]
      else
        @_blueprint_data
      end
    end

    def build(*names)
      build_with nil, *names
    end

    def build!(*names)
      build_with :create, *names
    end

    def build_new(*names)
      build_with :new, *names
    end

    def build_attributes(*names)
      build_with :attributes, *names
    end

    def build_with(strategy, *names)
      BlueprintsBoy.manager.build(self, names, strategy: strategy)
    end

    def blueprints
      BlueprintsBoy.blueprints
    end

    def blueprint(name, *args, **options, &block)
      def self.blueprints
        @blueprints ||= Blueprints.new(super)
      end

      DSL.new(blueprints, blueprints.find(name).dup).blueprint(name, *args, **options, &block)

      instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{name}
          build(:#{name})
        end
      RUBY
    end
  end
end
