require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'mysql2', database: 'blueprints_boy_test')

class ARFruit < ActiveRecord::Base
  self.table_name = 'fruits'
  attr_protected :species
end
