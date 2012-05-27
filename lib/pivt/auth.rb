module Pivt::Auth
  @@api_url = 'https://www.pivotaltracker.com/services/v3/'

  def self.config(options={})
    @auth = {}
    if !options[:token].nil?
      @auth[:token] = options[:token]
    elsif !options[:username].nil? && !options[:password].nil?
      @auth[:token] = fetch_token(options[:username], options[:password])
    end

    @auth[:name] = options[:name]
    @auth[:project_id] = options[:project_id]
  end

  def self.fetch_token(username, password)
    auth = {:username => username, :password => password}
    response = HTTParty.get(@@api_url + 'tokens/active', {:basic_auth => auth})
    response['token']['guid']
  end

  def self.auth
    raise 'No Name' if @auth[:name].nil?
    raise 'No Project ID' if @auth[:project_id].nil?
    raise 'No Token' if @auth[:token].nil?
    @auth
  end

end