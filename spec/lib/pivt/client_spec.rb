require 'spec_helper'
describe Pivt::Client do

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

    Pivt::Client.config({:token => 'usertoken', :name => 'Andrew Terris', :project_id => '5'})
  end

  it 'can return authentication details' do
    Pivt::Client.config({:token => 'usertoken', :name => 'Andrew Terris', :project_id => '5'})
    Pivt::Client.token.should == 'usertoken'
    Pivt::Client.name.should == 'Andrew Terris'
    Pivt::Client.project_id.should == '5'
  end

  it 'can generate a token when given username and password' do
    Pivt::Client.config({:username => 'atterris@gmail.com', :password => 'pwd', :name => 'Andrew Terris', :project_id => '5'})
    Pivt::Client.token.should == 'usertoken'
  end
  
  it 'requires a name' do
    lambda {Pivt::Client.config({:token => 'usertoken', :project_id => '5'})}.
      should raise_error('No Name')
  end

  it 'requires a project id' do
    lambda {Pivt::Client.config({:token => 'usertoken', :name => 'Andrew Terris'})}.
      should raise_error('No Project ID')
  end

  it 'requires a token' do
    lambda {Pivt::Client.config({:name => 'Andrew Terris', :project_id => '5'})}.
      should raise_error('No Token')
  end

  it 'can fetch a token' do
    Pivt::Client.fetch_token('atterris@gmail.com', 'pwd')
    WebMock.should have_requested(:get, "https://atterris%40gmail.com:pwd@www.pivotaltracker.com/services/v3/tokens/active").once
  end

  it 'can determine if we have complete authentication info' do
    lambda {Pivt::Client.valid?}.
      should_not raise_error

    token = Pivt::Client.token
    Pivt::Client.token = nil
    lambda {Pivt::Client.valid?}.
      should raise_error('No Token')
    Pivt::Client.token = token

    name = Pivt::Client.name
    Pivt::Client.name = nil
    lambda {Pivt::Client.valid?}.
      should raise_error('No Name')
    Pivt::Client.name = name

    project_id = Pivt::Client.project_id
    Pivt::Client.project_id = nil
    lambda {Pivt::Client.valid?}.
      should raise_error('No Project ID')
    Pivt::Client.project_id = project_id
  end

  it 'can make a GET API request' do
    stub_request(:get, "https://www.pivotaltracker.com/services/v3/get")
    Pivt::Client.get("get")
    WebMock.should have_requested(:get, "https://www.pivotaltracker.com/services/v3/get").
      with(:headers => {'X-TrackerToken' => 'usertoken'}).once
  end

  it 'can make a POST API request' do
    stub_request(:post, "https://www.pivotaltracker.com/services/v3/post")
    Pivt::Client.post("post")
    WebMock.should have_requested(:post, "https://www.pivotaltracker.com/services/v3/post").
      with(:headers => {'Content-Type'=>'application/xml', 'X-TrackerToken' => 'usertoken'}).once
  end

  it 'can make a PUT API request' do
    stub_request(:put, "https://www.pivotaltracker.com/services/v3/put")
    Pivt::Client.put("put")
    WebMock.should have_requested(:put, "https://www.pivotaltracker.com/services/v3/put").
      with(:headers => {'Content-Type'=>'application/xml', 'X-TrackerToken' => 'usertoken'}).once
  end

  it 'can make a DELETE API request' do
    stub_request(:delete, "https://www.pivotaltracker.com/services/v3/delete")
    Pivt::Client.delete("delete")
    WebMock.should have_requested(:delete, "https://www.pivotaltracker.com/services/v3/delete").
      with(:headers => {'X-TrackerToken' => 'usertoken'}).once
  end

  it 'can merge in authentication options' do
    options = {:headers => {'Content-length' => '0'}}
    options = Pivt::Client.auth_options(options)
    options[:headers].should == {'Content-length' => '0', 'X-TrackerToken' => 'usertoken'}
  end

  it 'can merge in xml content options' do
    options = {:headers => {'Content-length' => '0'}}
    options = Pivt::Client.xml_options(options)
    options[:headers].should == {'Content-length' => '0', 'Content-type' => 'application/xml'}
  end

  it 'can validate an API response' do
    response = ''
    lambda {Pivt::Client.validate_response!(response)}.
      should_not raise_error

    response = {'errors' => {'error' => ['PT Error']}}
    lambda {Pivt::Client.validate_response!(response)}.
      should raise_error('PT Error')

    response = {'message' => 'PT Message'}
    lambda {Pivt::Client.validate_response!(response)}.
      should raise_error('PT Message')
  end
end