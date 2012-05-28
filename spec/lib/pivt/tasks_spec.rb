require 'spec_helper'
describe Pivt::Tasks do

  before(:each) do
    # Fixtures
    @stories = YAML.load_file('spec/fixtures/stories.yaml')
    @story = YAML.load_file('spec/fixtures/story.yaml')
    
    Pivt::Client.stub(:get).and_return(@stories)
    
    @task = Pivt::Tasks.find(0)
  end

  it 'can return all tasks' do
    tasks = Pivt::Tasks.all
    tasks.length.should == 4
    
    tasks.each do |task|
      task.should_not be_nil
      task.class.should == Pivt::Tasks
      task.name.should_not be_nil
      task.name.class.should == String
    end
  end

  it 'can return a single task' do
    @task.name.should == 'Kill All Humans!'
    @task.description.should == 'We must kill all humans.'
    @task.current_state.should == 'started'
    @task.pivt_id.should == 0
  end

  it 'can create a new task' do
    obj = {
      :story => {
        :name => 'Test Name',
        :description => 'Test Description',
        :estimate => 1,
        :story_type => 'feature',
        :current_state => 'unstarted',
        :owned_by => 'Andrew Terris'
      }
    }
    Pivt::Client.should_receive(:post).with("stories", {:body=> obj.pivt_xml}).and_return(@story)
    Pivt::Client.name = 'Andrew Terris'
    
    options = {
      :name => 'Test Name',
      :description => 'Test Description',
      :estimate => 1
    }
    task = Pivt::Tasks.create(options)
    task.should_not be_nil
    task.class.should == Pivt::Tasks
  end

  it 'can be initialized' do
    task = Pivt::Tasks.new({'name' => 'New Task'}, {:pivt_id => 3})
    task.name.should == 'New Task'
    task.pivt_id.should == 3
  end

  it 'can be updated' do
    Pivt::Client.should_receive(:put).
      with("stories/28694861", {:body=>"<story><name>New Name</name></story>"}).and_return(@story)
    @task.update({:name => 'New Name'})
  end
  
  it 'can be deleted' do
    Pivt::Client.should_receive(:delete)
    @task.delete
  end 

  it 'can be format a started task' do
    string = @task.format
    string.should == "\n\e[32m  0. Kill All Humans!\e[0m\n      We must kill all humans.\n"
  end

  it 'can be format an unstarted task' do
    @task.current_state = 'unstarted'
    string = @task.format
    string.should == "  0. Kill All Humans!\n"
  end

  it 'can be moved' do
    Pivt::Client.should_receive(:post).
      with("stories/28694861/moves?move[move]=before&move[target]=30259951", {:headers=>{"Content-length"=>"0"}}).
      and_return(@story)

    @task.move 2
  end

  it 'can be pushed' do
    @task.should_receive(:move).with(@task.pivt_id + 2).and_return(@story)
    @task.push
  end

  it 'can be popped' do
    @task.pivt_id = 1
    @task.should_receive(:move).with(@task.pivt_id - 1).and_return(@story)
    @task.pop
  end

  it 'can be started' do
    @task.should_receive(:update).with({:current_state => 'started'}).and_return(@story)
    @task.start
  end

  it 'can be unstarted' do
    @task.should_receive(:update).with({:current_state => 'unstarted'}).and_return(@story)
    @task.unstart
  end

  it 'can be finished' do
    @task.should_receive(:update).with({:current_state => 'finished'}).and_return(@story)
    @task.finish
  end

  it 'can be delivered' do
    @task.should_receive(:update).with({:current_state => 'delivered'}).and_return(@story)
    @task.deliver
  end

  it 'can be accepted' do
    @task.should_receive(:update).with({:current_state => 'accepted'}).and_return(@story)
    @task.accept
  end

  it 'can be rejected' do
    @task.should_receive(:update).with({:current_state => 'rejected'}).and_return(@story)
    @task.reject
  end

  it 'can be estimated' do
    @task.should_receive(:update).with({:estimate => 2}).and_return(@story)
    @task.estimate(2)
  end

end