BlueprintsBoy.factories.add(Mongoid::Document) { |data| data.factory.create!(data.attributes, without_protection: true) }

DatabaseCleaner[:mongoid].strategy = :truncation
