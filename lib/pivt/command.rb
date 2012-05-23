module Pivt
  module Command
    def self.list global_options, options, args
      PivotalTracker::Client.token global_options[:u], global_options[:p]
    @project = PivotalTracker::Project.find(global_options[:project])
    @tasks = @project.stories.all(:mywork => 'Andrew Terris')

    count = 0
    @tasks.each do |task|
      case task.current_state
      when 'started'
        puts sprintf(" #{count}: #{task.id} - #{task.name}".color(:green))
      when 'unstarted'
        puts sprintf(" #{count}: #{task.id} - #{task.name}")
      when 'unscheduled'
      else
      end
      count += 1
    end
    end
  end
end