BlueprintsBoy.factories.add(ActiveRecord::Base, :create) { |data| data.factory.create!(data.attributes, without_protection: true) }
BlueprintsBoy.factories.add(ActiveRecord::Base, :new) { |data| data.factory.new(data.attributes, without_protection: true) }
BlueprintsBoy.factories.add(ActiveRecord::Base, :update) { |data| blueprint_data(data.name).update_attributes!(data.options, without_protection: true) }

DatabaseCleaner[:active_record].strategy = BlueprintsBoy.config.transactions ? :transaction : :truncation
