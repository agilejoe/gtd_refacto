require "yaml"
require 'rubygems'  
require 'active_record'

class Task < ActiveRecord::Base
  belongs_to :context, :class_name => "Context", :foreign_key => "Context_id"
  belongs_to :project, :class_name => "Project", :foreign_key => "Project_id"

  def to_s
    puts self.description
  end
end

class Context < ActiveRecord::Base
  has_many :tasks, :class_name => "Task", :foreign_key => "reference_id"
end

class Project < ActiveRecord::Base
  has_many :tasks, :class_name => "Task", :foreign_key => "reference_id"
end


module GTD

 module_function 
  def connect()
   dbconfig = YAML::load(File.open('config/database.yml'))
   ActiveRecord::Base.establish_connection(dbconfig)
  end
  
  def process_command(cmd)
    args = Array(cmd)
    command = args.shift
    case(command)
      when "+" 
        add_task(args[0])     
      when "t" 
        t = Task.find(:all)
        t.empty? ? puts("Go drink a beer! You're all done!\n") : tasks_write_to_screen(t)
      when "p"
        p = Project.find(:all)
        p.empty? ? puts("I don't see any projects.\n") : projects_write_to_screen(p)
      when "c"
        c = Context.find(:all)
        c.empty? ? puts("Looks like you have nothing to do.\n") : context_write_to_screen(c)
      when "?"
        puts"task desciption that is going to get things done [Project] (Context)"
        puts"EXAMPLE: \"+ pick up bread at the store [Home](Grocery)\""
      else
        puts "#{cmd} command unrecognized?" 
    end
  end
  
  def tasks_write_to_screen(tasks)
    puts "Tasks List"
    puts "-----------------------------------------------------------------------------"
    tasks.each do |task|
      puts task.project.name + ' ' +task.id.to_s + ' ' + task.description + ' ' + task.context.name
    end
  end
  
  def projects_write_to_screen(projects)
    puts "Project List"
    puts "-----------------------------------------------------------------------------"
    projects.each do |project|
      puts project.id.to_s + ' ' + project.name
    end
  end
  
  def context_write_to_screen(contexts)
    puts "Context List"
    puts "-----------------------------------------------------------------------------"
    contexts.each do |context|
      puts context.id.to_s + ' ' + context.name
    end
  end

  def add_task(description)

    task_desc = parse_task(description)
    task = Task.create(:description => task_desc)

    if (project=parse_project(description))
      proj = Project.find_or_create_by_name(project)
      task.Project_id = proj.id
      proj.save
    end

    if (context=parse_context(description))
      con = Context.find_or_create_by_name(context)
      task.Context_id = con.id
      con.save
    end
    
    task.save
    
  end

  def parse_project(string)
    string =~ /<(.*)>/ && $1.strip
  end

  def parse_task(string)
    string.gsub(/[<\[].*[>\]]/,"").strip
  end

  def parse_context(string)
    string =~ /\[(.*)\]/ && $1.strip
  end

end
