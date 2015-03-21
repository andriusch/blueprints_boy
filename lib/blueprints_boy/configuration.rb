module BlueprintsBoy
  # Contains configuration of blueprints. Instance of this is yielded in Blueprints.enable block.
  # @example Configuring through Blueprints.enable block
  #   Blueprints.enable do |config|
  #     config.global = :user, :profile
  #   end
  # @example Configuring directly
  #   Blueprints.config.transactions = false
  class Configuration
    # Allows passing custom filename pattern in case blueprints are held in place other than spec/blueprints, test/blueprints, blueprints.
    attr_reader :filenames
    # Allows passing custom root folder to use in case of non rails project. Defaults to Rails.root or current folder if Rails is not defined.
    attr_reader :root
    # By default blueprints runs each test in it's own transaction. This may sometimes be not desirable so this options allows to turn this off.
    attr_accessor :transactions
    # Define global blueprints that are prebuilt in all tests
    attr_reader :global

    # Initializes new Configuration object with default attributes.
    def initialize
      self.filenames = [nil, "spec", "test"].map do |dir|
        ['blueprints.rb', 'blueprints/*.rb'].map do |pattern|
          File.join([dir, pattern].compact)
        end
      end
      @transactions = true
      @root = defined?(Rails) ? Rails.root : Pathname.pwd
      @global = []
    end

    def filenames=(value)
      @filenames = Array(value).flatten.collect { |path| Pathname.new(path) }
    end

    def root=(value)
      @root = Pathname.new(value)
    end

    def global=(value)
      @global = Array(value)
    end
  end
end
