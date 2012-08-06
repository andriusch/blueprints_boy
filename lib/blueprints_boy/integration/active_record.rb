BlueprintsBoy.factories.add(ActiveRecord::Base) { |factory_class| factory_class.create!(attributes, without_protection: true) }

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
