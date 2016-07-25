require 'active_record'
require 'mysql2'
require 'yaml'
ActiveRecord::Base.configurations = YAML.load_file(File.expand_path('../database.yml', __FILE__))
ActiveRecord::Base.establish_connection(:default_env)

class ARFruit < ActiveRecord::Base
  self.table_name = 'fruits'
  attr_protected :species if ActiveRecord::VERSION::MAJOR < 4
end
