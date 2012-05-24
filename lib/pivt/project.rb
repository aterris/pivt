class Pivt::Project
  
  def initialize(username, password, project_id)
    PivotalTracker::Client.token username, password
    @project = PivotalTracker::Project.find(project_id)
  end

  def tasks
    @project.stories.all(:mywork => 'Andrew Terris')
  end

  def find_task id
    if id < 10
      task = tasks()[id]
    else
      task = @project.stories.find(id)
    end

    task
  end

  def create_task
  end

  def start_task id
    find_task(id).update(:current_state => 'started')
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

  def print_tasks
    count = 0
    tasks.each do |task|
      print_task(task, count)
      count += 1
    end
  end

  def print_task(task, index)
    case task.current_state
    when 'started'
      puts "\n"
      puts "  #{index}. #{task.name} #{task.id}".color(:green) 
      puts "       Lorem ipsum dolor sit amet.  That is all i know by heart"
      puts "       Lorem ipsum dolor sit amet.  That is all i know by heart"
      puts "\n"
    when 'unstarted'
      puts "  #{index}. #{task.name} #{task.id}"
      puts "\n"
    when 'unstarted'
    when 'unscheduled'
    else
    end
  end

end