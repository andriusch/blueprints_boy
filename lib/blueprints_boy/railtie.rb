class BlueprintsBoy::Railtie < Rails::Railtie
  class Seeder
    def initialize(parent)
      @parent = parent
    end

    def load_seed
      BlueprintsBoy.enable

      TOPLEVEL_BINDING.eval('self').instance_eval do
        @_blueprint_data = {}
        include BlueprintsBoy::Helper
      end

      @parent.load_seed
    end
  end

  initializer 'blueprints_boy.set_seed_loader' do
    ActiveRecord::Tasks::DatabaseTasks.seed_loader = Seeder.new(ActiveRecord::Tasks::DatabaseTasks.seed_loader)
  end
end
