BlueprintsBoy.factories.add(Mongoid::Document, :create) { |data| data.factory.create!(data.attributes, without_protection: true) }
BlueprintsBoy.factories.add(Mongoid::Document, :new) { |data| data.factory.new(data.attributes, without_protection: true) }

DatabaseCleaner[:mongoid].strategy = :truncation
