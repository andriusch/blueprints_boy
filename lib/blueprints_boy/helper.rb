module BlueprintsBoy::Helper
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
    BlueprintsBoy.manager.build(self, names)
  end

  def build!(*names)
    BlueprintsBoy.manager.build(self, names, strategy: :create)
  end

  def build_new(*names)
    BlueprintsBoy.manager.build(self, names, strategy: :new)
  end

  def build_with(strategy, *names)
    BlueprintsBoy.manager.build(self, names, strategy: strategy)
  end
end
