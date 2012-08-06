module BlueprintsBoy::Helper
  def set(name, value)
    @_blueprint_results[name] = value
    instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      def self.#{name}
        @_blueprint_results[:#{name}]
      end
    RUBY
  end

  def autoset(name, value)
    set(name, value) unless respond_to?(name)
  end

  def fixtures(name)
    @_blueprint_results[name]
  end

  def build(*names)
    BlueprintsBoy.manager.build(self, names)
  end
end
