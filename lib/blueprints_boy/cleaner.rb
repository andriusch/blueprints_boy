# frozen_string_literal: true

module BlueprintsBoy
  class Cleaner
    def before_suite
      DatabaseCleaner.clean_with(:deletion) if database_cleaner?
    end

    def on_setup
      DatabaseCleaner.start if database_cleaner?
    end

    def on_teardown
      DatabaseCleaner.clean if database_cleaner?
    end

    private

    def database_cleaner?
      defined?(DatabaseCleaner)
    end
  end
end
