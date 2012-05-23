module Pivt::Command
  def self.list global_options, options, args
    @project = Pivt::Project.new global_options[:u], global_options[:p], global_options[:project]
    print_tasks()
  end
end