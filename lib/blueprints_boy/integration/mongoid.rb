require 'database_cleaner/mongoid'

BlueprintsBoy.factories.add(Mongoid::Document, :create) { |factory:, attributes:| factory.create!(attributes) }
BlueprintsBoy.factories.add(Mongoid::Document, :new) { |factory:, attributes:| factory.new(attributes) }
BlueprintsBoy.factories.add(Mongoid::Document, :update) { |name:, options:| blueprint_data(name).update_attributes!(options) }

DatabaseCleaner[:mongoid].strategy = :deletion
