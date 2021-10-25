# frozen_string_literal: true

module BlueprintsBoy
  class Registry
    attr_reader :built, :parent, :names

    def initialize(names, parent)
      @names = names
      @parent = parent
      @built = Set.new
      @built.merge(parent.built) if parent

      @stored = {}
    end

    def store(data)
      data.each do |name, value|
        @stored[name] = Marshal.dump(value)
      end
    end

    def restore
      data = @stored.transform_values { |dump| Marshal.load(dump) } # rubocop:disable Security/MarshalLoad
      data.reverse_merge!(@parent.restore) if @parent
      data
    end
  end
end
