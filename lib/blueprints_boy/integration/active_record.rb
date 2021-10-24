require 'database_cleaner/active_record'

BlueprintsBoy.factories.add(ActiveRecord::Base, :create) { |attributes:, factory:| factory.create!(attributes) }
BlueprintsBoy.factories.add(ActiveRecord::Base, :new) { |attributes:, factory:| factory.new(attributes) }
BlueprintsBoy.factories.add(ActiveRecord::Base, :update) { |options:, name:| blueprint_data(name).update!(options) }

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
