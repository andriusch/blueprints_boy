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
  end

  def blueprint_data(name)
    @_blueprint_data[name]
  end

  def build(*names)
    BlueprintsBoy.manager.build(self, names)
  end
end
