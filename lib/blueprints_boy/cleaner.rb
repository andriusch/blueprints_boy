# frozen_string_literal: true
module BlueprintsBoy
  class Cleaner
    def before_suite
      ignore_no_orm do
        DatabaseCleaner.clean_with(:truncation)
      end
    end

    def on_setup
      ignore_no_orm do
        DatabaseCleaner.start
      end
    end

    def on_teardown
      ignore_no_orm do
        DatabaseCleaner.clean
      end
    end

    private

    def ignore_no_orm
      yield
    rescue DatabaseCleaner::NoORMDetected # rubocop:disable Lint/HandleExceptions
    end
  end
end
