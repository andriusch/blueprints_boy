require 'active_record'
require 'mysql2'
ActiveRecord::Base.establish_connection(adapter: 'mysql2', database: 'blueprints_boy_test')

class ARFruit < ActiveRecord::Base
  self.table_name = 'fruits'
  attr_protected :species if ActiveRecord::VERSION::MAJOR < 4
end
