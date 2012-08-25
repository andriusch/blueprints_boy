BlueprintsBoy.factories.add(ActiveRecord::Base) { |data| data.factory.create!(data.attributes, without_protection: true) }

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
