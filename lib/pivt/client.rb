module Pivt::Client

  class << self
    attr_accessor :token, :name, :project_id
    API_URL = 'https://www.pivotaltracker.com/services/v3/'

    def config(options={})
      if !options[:token].nil?
        @token = options[:token]
      elsif !options[:username].nil? && !options[:password].nil?
        @token = fetch_token(options[:username], options[:password])
      else
        @token = nil
      end

      @name = options[:name]
      @project_id = options[:project_id]

      valid?
    end

    def fetch_token(username, password)
      auth = {:username => username, :password => password}
      response = HTTParty.get(API_URL + 'tokens/active', {:basic_auth => auth})
      validate_response!(response)
      response['token']['guid']
    end

    def valid?
      raise 'No Name' if @name.nil?
      raise 'No Project ID' if @project_id.nil?
      raise 'No Token' if @token.nil?
    end

    def get(endpoint, options={})
      auth_options(options)
      response = HTTParty.get(API_URL + "projects/#{@project_id}/" + endpoint, options)
      validate_response!(response)
    end

    def post(endpoint, options={})
      auth_options(options)
      xml_options(options)
      response = HTTParty.post(API_URL + "projects/#{@project_id}/" + endpoint, options)
      validate_response!(response)
    end

    def put(endpoint, options={})
      auth_options(options)
      xml_options(options)
      response = HTTParty.put(API_URL + "projects/#{@project_id}/" + endpoint, options)
      validate_response!(response)
    end

    def delete(endpoint, options={})
      auth_options(options)
      response = HTTParty.delete(API_URL + "projects/#{@project_id}/" + endpoint, options)
      validate_response!(response)
    end

    def auth_options(options={})
      raise 'No Token' if @token.nil?
      options[:headers] ||= {}
      options[:headers].merge!({'X-TrackerToken' => @token})
      options
    end

    def xml_options(options={})
      options[:headers] ||= {}
      options[:headers].merge!({'Content-type' => 'application/xml'})
      options
    end

    def validate_response!(response={})
      raise response['errors']['error'][0] if(!response['errors'].nil? && !response['errors']['error'].nil?)
      raise response['message'] if !response['message'].nil?
      response
    end

  end
end