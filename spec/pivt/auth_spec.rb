require 'spec_helper'
describe Pivt::Auth do

  before(:each) do
  	stub_request(:get, "https://atterris%40gmail.com:pwd@www.pivotaltracker.com/services/v3/tokens/active").
      to_return(:body => {'token'=> {'guid' => 'usertoken'}}.to_json, :headers => {'Content-Type' => 'application/json'})

    stub_request(:get, "https://www.pivotaltracker.com/services/v3/projects/5/stories?filter=mywork:Andrew%20Terris").
      with(:headers => {'X-Trackertoken'=>'usertoken'}).
      to_return(:headers => {'Content-Type' => 'application/json'}, :body => {:stories => [{
        :id => '123',
        :name => 'Test Task',
        :description => 'Test task description',
        :current_state => 'started'
        },
        {
        :id => '234',
        :name => 'Test Task 2',
        :description => 'Another test task description',
        :current_state => 'unstarted'
        }]}.to_json)
  end

  it 'can return authentication details' do
    Pivt::Auth.config({:token => 'usertoken', :name => 'Andrew Terris', :project_id => '5'})
    Pivt::Auth.auth()[:token].should == 'usertoken'
    Pivt::Auth.auth()[:name].should == 'Andrew Terris'
    Pivt::Auth.auth()[:project_id].should == '5'
  end

  it 'can generate a token when given username and password' do
    Pivt::Auth.config({:username => 'atterris@gmail.com', :password => 'pwd', :name => 'Andrew Terris', :project_id => '5'})
    Pivt::Auth.auth()[:token].should == 'usertoken'
  end
  
  it 'requires a name' do
    Pivt::Auth.config({:token => 'usertoken', :project_id => '5'})
    lambda {Pivt::Auth.auth}.
      should raise_error('No Name')
  end

  it 'requires a project id' do
    Pivt::Auth.config({:token => 'usertoken', :name => 'Andrew Terris'})
    lambda {Pivt::Auth.auth}.
      should raise_error('No Project ID')
  end

  it 'requires a token' do
    Pivt::Auth.config({:name => 'Andrew Terris', :project_id => '5'})
    lambda {Pivt::Auth.auth}.
      should raise_error('No Token')
  end

end