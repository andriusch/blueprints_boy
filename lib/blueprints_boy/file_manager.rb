module BlueprintsBoy
  class FileManager
    def initialize(name, manager)
      @name = name
      @manager = manager
      instance_eval(File.read(name), name)
    end

    def blueprint(*args, &block)
      @manager.add(Blueprint.new(*args, &block))
    end
    alias method_missing blueprint
  end
end
