class Pivt::Project
  
  def initialize(username, password, project_id)
    PivotalTracker::Client.token username, password
    @project = PivotalTracker::Project.find(project_id)
  end

  def list_tasks
    count = 0
    tasks.each do |task|
      case task.current_state
      when 'started'
        puts " #{count}: #{task.id} - #{task.name}".color(:green)
      when 'unstarted'
        puts " #{count}: #{task.id} - #{task.name}"
      when 'unscheduled'
      else
      end
      count += 1
    end
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

  def find_task id
    @project.stories.find(id)
  end

  def tasks
    @project.stories.all(:mywork => 'Andrew Terris')
  end

end