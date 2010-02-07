require "rubygems" 
require "rake" 
require "rake/testtask"
require 'active_record'
require 'yaml'

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << "test" 
  test.test_files = Dir[ "test/test_*.rb" ]
  test.verbose = true
end
namespace :db do
  
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Base.timestamped_migrations = false
    # ActiveRecord::Migrator.migrate('data/migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
    ActiveRecord::Migrator.migrate('data/migrations', nil)
  end

  desc "Created the connection to the database"
  task :environment do
    ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  end

  desc 'Create the database defined in config/database.yml for the current RAILS_ENV'
  task :create => :environment do
    create_database()
  end

  desc 'Drops all the local databases defined in config/database.yml'
  task :drop do
    drop_database()
  end


  def create_database()
    begin
      if File.exist?('data/gtd.db')
       puts "database already exists"
      else
        begin
          # Create the SQLite database
          ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
          ActiveRecord::Base.connection
        rescue
          puts $!, *($!.backtrace)
          puts "Couldn't create database for GTD"
        end
      end
      return # Skip the else clause of begin/rescue
    rescue
      puts("There was a rescue that occured")
    else
      puts "GTD database already exists"
    end
  end

  def drop_database()
      FileUtils.rm('data/gtd.db')
  end
end