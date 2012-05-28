require 'spec_helper'
describe Pivt::Tasks do

  before(:each) do
    Pivt::Client.stub(:get).and_return(YAML.load_file('spec/fixtures/stories.yaml'))
    @task = Pivt::Tasks.find(0)
  end

  it 'can return all tasks' do
    tasks = Pivt::Tasks.all
    tasks.length.should == 4
    1.should == 2
  end

  it 'can return a single task' do
    @task.name.should == 'Kill All Humans!'
    @task.description.should == 'We must kill all humans.'
    @task.current_state.should == 'started'
    @task.pivt_id.should == 0
  end

  it 'can create a new task' do
    Pivt::Client.should_receive(:post).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    options = {
      :name => 'a name'
    }
    task = Pivt::Tasks.create(options)
    raise task.inspect
  end

  it 'can be initialized'
  it 'can be updated' do
    Pivt::Client.should_receive(:put)
    @task.update
  end
  
  it 'can be deleted' do
    Pivt::Client.should_receive(:delete)
    @task.delete
  end 

  it 'can be printed'

  it 'can be moved'
  it 'can be popped'
  it 'can be pushed'

  it 'can be started' do
    @task.should_receive(:update).with({:current_state => 'started'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.start
  end

  it 'can be unstarted' do
    @task.should_receive(:update).with({:current_state => 'unstarted'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.unstart
  end

  it 'can be finished' do
    @task.should_receive(:update).with({:current_state => 'finished'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.finish
  end

  it 'can be delivered' do
    @task.should_receive(:update).with({:current_state => 'delivered'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.deliver
  end

  it 'can be accepted' do
    @task.should_receive(:update).with({:current_state => 'accepted'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.accept
  end

  it 'can be rejected' do
    @task.should_receive(:update).with({:current_state => 'rejected'}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.reject
  end

  it 'can be estimated' do
    @task.should_receive(:update).with({:estimate => 2}).and_return(YAML.load_file('spec/fixtures/story.yaml'))
    @task.estimate(2)
  end

end
