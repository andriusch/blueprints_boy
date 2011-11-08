module BlueprintsBoy::Helper
  def set(name, value)
    singleton_class.class_eval do
      define_method(name) { value }
    end
  end

  def build(name)
    BlueprintsBoy.manager.build(self, name)
  end
end
