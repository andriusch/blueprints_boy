module BlueprintsBoy
  class DSL
    attr_reader :context

    def self.from_file(file_name, manager)
      new(manager).instance_eval(File.read(file_name), file_name)
    end

    def initialize(manager, context = Context.new)
      @manager = manager
      @context = context
    end

    %i[depends_on attributes factory].each do |method|
      define_method(method) do |*args, &block|
        chain_context(block) { |context| context.public_send(method, *args) }
      end
    end

    def blueprint(*args, &block)
      @manager.add Blueprint.new(@context, *args, &block)
    end

    def group(groups)
      groups.collect do |name, children|
        depends_on(*children).blueprint(name) { blueprint_data.values_at(*children) }
      end
    end

    def dependency(name, *args, &block)
      BlueprintsBoy::Dependency.new(name, *args, &block)
    end

    alias_method :method_missing, :dependency

    private

    def chain_context(block)
      context = @context.dup
      yield context

      self.class.new(@manager, context).tap do |context_chain|
        context_chain.instance_eval(&block) if block
      end
    end
  end
end
