module Pivt::Auth

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
      response['token']['guid']
    end

    def valid?
      raise 'No Name' if @name.nil?
      raise 'No Project ID' if @project_id.nil?
      raise 'No Token' if @token.nil?
    end

    def api_url
      API_URL
    end
  end
end