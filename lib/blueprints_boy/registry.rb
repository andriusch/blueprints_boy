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
      data = @stored.each_with_object({}) do |(name, dump), result|
        result[name] = Marshal.load(dump)
      end
      data.reverse_merge!(@parent.restore) if @parent
      data
    end
  end
end
