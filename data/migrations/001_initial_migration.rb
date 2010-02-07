class InitialMigration < ActiveRecord::Migration
  def self.up    
    create_table :tasks do |t|
      t.column "description", :string
      t.column "status", :string
      t.column "Context_id", :integer
      t.column "Project_id", :integer
    end

    create_table :contexts do |t|
      t.column "name", :string
    end

    create_table :projects do |t|
      t.column "name", :string
    end
  end

  def self.down
    drop_table :tasks
    drop_table :projects
    drop_table :contexts
  end
end
