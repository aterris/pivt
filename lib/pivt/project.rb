class Pivt::Project
  
  def initialize(username, password, project_id)
    PivotalTracker::Client.token username, password
    @project = PivotalTracker::Project.find(project_id)
  end

  def tasks
    @project.stories.all(:mywork => 'Andrew Terris')
  end

  def find_task id
    if Integer(id) < 10
      task = tasks()[Integer(id)]
    else
      task = @project.stories.find(id)
    end

    task
  end

  def create_task name, options
    task = {
      :name => name,
      :description => options[:description],
      :estimate => options[:estimate],
      :story_type => options[:type],
      :current_state => ( options[:open] ? 'started' : 'unstarted' ),
      :owned_by => 'Andrew Terris'
    }
    @project.stories.create(task)
  end

  def move_task id, position
  end

  def pop_task id
  end

  def push_task id
  end

  def start_task id
    find_task(id).update(:current_state => 'started')
  end

  def unstart_task id
    find_task(id).update(:current_state => 'unstarted')
  end

  def finish_task id
    find_task(id).update(:current_state => 'finished')
  end

  def deliver_task id
    find_task(id).update(:current_state => 'delivered')
  end

  def accept_task id
    find_task(id).update(:current_state => 'accepeted')
  end

  def reject_task id
    find_task(id).update(:current_state => 'rejected')
  end

  def delete_task id

  end

  def print_tasks
    tasks.each_with_index do |task, index|
      print_task(task, index)
    end
  end

  def print_task(task, index)
    case task.current_state
    when 'started'
      puts "\n"
      puts "  #{index}. #{task.name}".color(:green)
      unless task.description.nil?
        task.description.scan(/.{72}/).each do |output|
          puts "      " + output
        end
      end
      puts "\n"
    when 'unstarted'
      puts "  #{index}. #{task.name}"
      puts "\n"
    end
  end

end