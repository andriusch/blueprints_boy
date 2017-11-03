# frozen_string_literal: true
if ActiveRecord::VERSION::MAJOR < 4
  BlueprintsBoy.factories.add(ActiveRecord::Base, :create) { |attributes:, factory:| factory.create!(attributes, without_protection: true) }
  BlueprintsBoy.factories.add(ActiveRecord::Base, :new) { |attributes:, factory:| factory.new(attributes, without_protection: true) }
  BlueprintsBoy.factories.add(ActiveRecord::Base, :update) { |options:, name:| blueprint_data(name).update_attributes!(options, without_protection: true) }
else
  BlueprintsBoy.factories.add(ActiveRecord::Base, :create) { |attributes:, factory:| factory.create!(attributes) }
  BlueprintsBoy.factories.add(ActiveRecord::Base, :new) { |attributes:, factory:| factory.new(attributes) }
  BlueprintsBoy.factories.add(ActiveRecord::Base, :update) { |options:, name:| blueprint_data(name).update_attributes!(options) }
end

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
