BlueprintsBoy.factories.add(Mongoid::Document) { |factory_class| factory_class.create!(attributes, without_protection: true) }

DatabaseCleaner[:mongoid].strategy = :truncation
