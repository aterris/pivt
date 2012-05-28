require 'spec_helper'
describe Pivt::Tasks do

  before(:each) do
    Pivt::Client.stub(:get).and_return(YAML.load_file('spec/fixtures/stories.yaml'))
  end

  it 'can return all tasks' do
    tasks = Pivt::Tasks.all
    tasks.length.should == 4
    1.should == 2
  end

  it 'can return a single task' do
    task = Pivt::Tasks.find(0)
    task.name.should == 'Kill All Humans!'
    task.description.should == 'We must kill all humans.'
    task.current_state.should == 'started'
    task.pivt_id.should == 0
  end

  it 'can create a new task'

  it 'can be initialized'
  it 'can be updated'
  it 'can be deleted'
  it 'can be printed'

  it 'can be moved'
  it 'can be popped'
  it 'can be pushed'

  it 'can be started'
  it 'can be unstarted'
  it 'can be finished'
  it 'can be delivered'
  it 'can be accepeted'
  it 'can be rejectd'
  it 'can be estimated'

end
