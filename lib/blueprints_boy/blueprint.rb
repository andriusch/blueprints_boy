# frozen_string_literal: true
module BlueprintsBoy
  class Blueprint
    attr_accessor :name, :dependencies, :attributes, :factory_class, :strategies

    def initialize
      self.name = nil
      self.dependencies = []
      self.attributes = {}
      self.factory_class = nil
      self.strategies = {attributes: proc { |attributes:| attributes }}
    end

    [:dependencies, :attributes, :strategies].each do |method|
      class_eval <<-RUBY
        def #{method}=(value)
          @#{method} = value.freeze
        end
      RUBY
    end
  end
end
