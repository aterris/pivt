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

  def finish_task id
    task = find(id)
    task.update(:current_state => 'finished')
  end

  def find id
    @project.stories.find(id)
  end

  def tasks
    @project.stories.all(:mywork => 'Andrew Terris')
  end

end