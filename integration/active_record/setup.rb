require 'active_record'
require 'pg'
require 'yaml'

path = Pathname(__dir__).join('database.yml')
ActiveRecord::Base.configurations = YAML.load_file(path) if path.exist?
ActiveRecord::Base.establish_connection

class ARFruit < ActiveRecord::Base
  self.table_name = 'fruits'
  attr_protected :species if ActiveRecord::VERSION::MAJOR < 4
end
