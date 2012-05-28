require 'spec_helper'
describe Pivt::Tasks do

  before(:each) do
  end

  it 'can return all tasks'
  it 'can return a single task'
  it 'can create a new task'

  it 'can be initialized'
  it 'can be updated'
  it 'can be deleted'
  it 'can be printed'

  it 'can be moved'
  it 'can be popped'
  it 'can be pushed'

  it 'can be started' do
    task = Pivt::Tasks.find(args[0])
    task.current_status.should == 'unstarted'
    task.start
    task.current_status.should == 'started'
  end
  it 'can be unstarted'
  it 'can be finished'
  it 'can be delivered'
  it 'can be accepeted'
  it 'can be rejectd'
  it 'can be estimated'

end
