module BlueprintsBoy::Helper
  def set(name, value)
    @_fixtures[name] = value
    instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      def self.#{name}
        @_fixtures[:#{name}]
      end
    RUBY
  end

  def autoset(name, value)
    set(name, value) unless respond_to?(name)
  end

  def fixtures(name)
    @_fixtures[name]
  end

  def build(*names)
    BlueprintsBoy.manager.build(self, names)
  end
end
