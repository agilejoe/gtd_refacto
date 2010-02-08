require 'gtd'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))