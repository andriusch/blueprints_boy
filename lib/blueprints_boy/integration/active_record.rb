require 'database_cleaner'
BlueprintsBoy.factories.add(ActiveRecord::Base) { |factory_class| factory_class.create!(attributes, without_protection: true) }

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
DatabaseCleaner.clean_with(:truncation)

BlueprintsBoy.manager.before_test do
  DatabaseCleaner.start
end

BlueprintsBoy.manager.after_test do
  DatabaseCleaner.clean
end
