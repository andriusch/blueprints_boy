# frozen_string_literal: true

module BlueprintsBoy
  class Blueprints
    def initialize(parent = nil)
      @parent = parent
      @collection = {}
    end

    def set(blueprint)
      @collection[blueprint.name] = blueprint
    end

    def find(name)
      @collection.fetch(name) do
        if @parent
          @parent.find(name)
        else
          fail BlueprintNotFound, "Blueprint :#{name} cannot be found"
        end
      end
    end

    alias [] find
  end
end
