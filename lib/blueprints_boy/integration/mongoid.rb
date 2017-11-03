# frozen_string_literal: true
if Mongoid::VERSION.to_i < 4
  BlueprintsBoy.factories.add(Mongoid::Document, :create) { |factory:, attributes:| factory.create!(attributes, without_protection: true) }
  BlueprintsBoy.factories.add(Mongoid::Document, :new) { |factory:, attributes:| factory.new(attributes, without_protection: true) }
  BlueprintsBoy.factories.add(Mongoid::Document, :update) { |name:, options:| blueprint_data(name).update_attributes!(options, without_protection: true) }
else
  BlueprintsBoy.factories.add(Mongoid::Document, :create) { |factory:, attributes:| factory.create!(attributes) }
  BlueprintsBoy.factories.add(Mongoid::Document, :new) { |factory:, attributes:| factory.new(attributes) }
  BlueprintsBoy.factories.add(Mongoid::Document, :update) { |name:, options:| blueprint_data(name).update_attributes!(options) }
end

DatabaseCleaner[:mongoid].strategy = :truncation
