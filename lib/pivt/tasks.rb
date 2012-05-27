class Hash
  def pivt_xml
    xml = ''
    self.each do |key, value|
      if value.is_a?(Hash)
        xml += "<#{key.to_s}>#{value.pivt_xml}</#{key.to_s}>"
      else
        xml += "<#{key.to_s}>#{value.to_s}</#{key.to_s}>"
      end
    end
    xml
  end
end

class Pivt::Tasks
  @@api_url = 'https://www.pivotaltracker.com/services/v3/'
  attr_accessor :name, :description, :position, :id
  
  def self.all
    query = {:filter => "mywork:#{Pivt::Auth.name}"}
    headers = {'X-TrackerToken' => Pivt::Auth.auth[:token]}
    response = HTTParty.get(@@api_url + "projects/#{Pivt::Auth.auth[:project_id]}/stories", {:query => query, :headers => headers})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)

    tasks = []
    stories = response['stories'] || []
    stories.each_with_index do |story, index|
      tasks.push self.new(story, {:token => Pivt::Auth.auth[:token], :project_id => Pivt::Auth.project_id, :pivt_id => index})
    end
    tasks
  end

  def self.find(id)
    self.all()[id.to_i]
  end

  def self.create(attributes={})
    headers = {'X-TrackerToken' => Pivt::Auth.auth[:token], 'Content-Type' => 'application/xml'}
    body = {
      :story => {
        :name => attributes[:name],
        :description => attributes[:description],
        :estimate => attributes[:estimate],
        :story_type => attributes[:type],
        :current_state => ( attributes[:open] ? 'started' : 'unstarted' ),
        :owned_by => Pivt::Auth.name
      }
    }

    response = HTTParty.post(@@api_url + "projects/#{Pivt::Auth.project_id}/stories", {:headers => headers, :body => body.pivt_xml})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)
    
    self.new(response['story'], {:token => Pivt::Auth.auth[:token], :project_id => Pivt::Auth.project_id})
  end

  def initialize(attributes={}, options={})
    set_attributes(attributes)

    @token = options[:token]
    @project_id = options[:project_id]
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
    headers = {'X-TrackerToken' => Pivt::Auth.auth[:token], 'Content-type' => 'application/xml'}
    body = {:story => attributes}
    response = HTTParty.put(@@api_url + "projects/#{Pivt::Auth.project_id}/stories/#{@id}", {:headers => headers, :body => body.pivt_xml})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)

    set_attributes(response['story'])
    self
  end

  def delete
    headers = {'X-TrackerToken' => Pivt::Auth.token}
    response = HTTParty.delete(@@api_url + "projects/#{Pivt::Auth.project_id}/stories/#{@id}", {:query => query, :headers => headers})

    raise response['errors']['error'][0].inspect if(!response['errors'].nil? && !response['errors']['error'].nil?)

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

  def move_before id
  end

  def move_after id
  end

  def move
  end

  def pop
  end

  def push
  end

  def estimate
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

  def meta
    # start, unstart, finish, deliver, accept, reject
  end

end