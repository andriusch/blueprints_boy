module BlueprintsBoy::Helper
  def set(name, value)
    @_blueprint_data[name] = value
    instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      def self.#{name}
        @_blueprint_data[:#{name}]
      end
    RUBY
  end

  def autoset(name, value)
    set(name, value) unless respond_to?(name)
  end

  def blueprint_data(name)
    @_blueprint_data[name]
  end

  def build(*names)
    BlueprintsBoy.manager.build(self, names)
  end
end
