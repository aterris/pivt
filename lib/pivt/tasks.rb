class Pivt::Tasks
  attr_accessor :name, :description, :position, :id, :pivt_id
  
  def self.all
    query = {:filter => "mywork:#{Pivt::Auth.name}"}
    headers = {'X-TrackerToken' => Pivt::Auth.token}
    response = HTTParty.get(Pivt::Auth.api_url + "projects/#{Pivt::Auth.project_id}/stories", {:query => query, :headers => headers})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    raise response['message'].inspect if !response['message'].nil?

    @tasks = []
    stories = response['stories'] || []
    stories.each_with_index do |story, index|
      @tasks.push self.new(story, {:pivt_id => index})
    end
    @tasks
  end

  def self.find(id)
    @tasks ||= self.all
    @tasks[id.to_i]
  end

  def self.create(attributes={})
    headers = {'X-TrackerToken' => Pivt::Auth.token, 'Content-Type' => 'application/xml'}
    body = {
      :story => {
        :name => attributes[:name],
        :description => attributes[:description],
        :estimate => attributes[:estimate],
        :story_type => attributes[:type],
        :current_state => ( attributes[:open] ? 'started' : 'unstarted' ),
        :owned_by => Pivt::Auth.auth[:name]
      }
    }

    response = HTTParty.post(Pivt::Auth.API_URL + "projects/#{Pivt::Auth.project_id}/stories", {:headers => headers, :body => body.pivt_xml})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    raise response['message'].inspect if !response['message'].nil?
    
    self.new(response['story'])
  end

  def initialize(attributes={}, options={})
    set_attributes(attributes)
    @pivt_id = options[:pivt_id]
  end

  def set_attributes(attributes)
    @id = attributes['id']
    @name = attributes['name']
    @description = attributes['description']
    @current_state = attributes['current_state']
    @owned_by = attributes['owned_by']
    @requested_by = attributes['requested_by']
    @labels = attributes['labels']
  end

  def update(attributes={})
    headers = {'X-TrackerToken' => Pivt::Auth.token, 'Content-type' => 'application/xml'}
    body = {:story => attributes}
    response = HTTParty.put(Pivt::Auth.API_URL + "projects/#{Pivt::Auth.project_id}/stories/#{@id}", {:headers => headers, :body => body.pivt_xml})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    raise response['message'].inspect if !response['message'].nil?

    set_attributes(response['story'])
    self
  end

  def delete
    headers = {'X-TrackerToken' => Pivt::Auth.token}
    response = HTTParty.delete(Pivt::Auth.API_URL + "projects/#{Pivt::Auth.project_id}/stories/#{@id}", {:query => query, :headers => headers})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    raise response['message'].inspect if !response['message'].nil?

    puts 'deleted task'
  end

  def print
    case @current_state
    when 'started'
      puts "\n"
      puts "  #{@pivt_id}. #{@name}".color(:green)
      unless @description.nil?
        @description.scan(/.{72}/).each do |output|
          puts "      " + output
        end
      end
      puts "\n"
    when 'unstarted'
      puts "  #{@pivt_id}. #{@name}"
      puts "\n"
    end
  end

  def move id
    headers = {'X-TrackerToken' => Pivt::Auth.token}
    params = "moves?move\[move\]=before&move\[target\]=#{self.find(id).id}"
    puts params
    response = HTTParty.put(Pivt::Auth.API_URL + "projects/#{Pivt::Auth.project_id}/stories/#{@id}/#{params}", {:headers => headers})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    raise response['message'].inspect if !response['message'].nil?

    set_attributes(response['story'])

  end

  def pop
  end

  def push
  end

  def start
    update(:current_state => 'started')
  end

  def unstart
    update(:current_state => 'unstarted')
  end

  def finish
    update(:current_state => 'finished')
  end

  def deliver
    update(:current_state => 'delivered')
  end

  def accept
    update(:current_state => 'accepted')
  end

  def reject
    update(:current_state => 'rejected')
  end

  def estimate score
    update(:estimate => score)
  end

  def meta
    # start, unstart, finish, deliver, accept, reject
  end

end