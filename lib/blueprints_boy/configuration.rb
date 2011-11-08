module BlueprintsBoy
  # Contains configuration of blueprints. Instance of this is yielded in Blueprints.enable block.
  # @example Configuring through Blueprints.enable block
  #   Blueprints.enable do |config|
  #     config.prebuild = :user, :profile
  #   end
  # @example Configuring directly
  #   Blueprints.config.transactions = false
  class Configuration
    # Allows passing custom filename pattern in case blueprints are held in place other than spec/blueprint, test/blueprint, blueprint.
    attr_reader :filenames
    # Allows passing scenarios that should be prebuilt and available in all tests. Works similarly to fixtures.
    attr_accessor :prebuild
    # Allows passing custom root folder to use in case of non rails project. Defaults to Rails.root or current folder if Rails is not defined.
    attr_reader :root
    # By default blueprints runs each test in it's own transaction. This may sometimes be not desirable so this options allows to turn this off.
    attr_accessor :transactions

    # Initializes new Configuration object with default attributes.
    # By defaults filename patterns are: blueprint.rb and blueprint/*.rb in spec, test and root directories.
    # Also by default prebuildable blueprints list is empty, transactions are enabled and root is set to Rails.root or current directory.
    def initialize
      self.filenames = [nil, "spec", "test"].map do |dir|
        File.join([dir, 'blueprints/*.rb'].compact)
      end
      @prebuild = []
      @transactions = false
      @root = defined?(Rails) ? Rails.root : Pathname.pwd
    end

    def filenames=(value)
      @filenames = Array(value).flatten.collect { |path| Pathname.new(path) }
    end

    def root=(value)
      @root = Pathname.new(value)
    end
  end
end
