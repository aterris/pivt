class Pivt::Tasks
  attr_accessor :name, :description, :position, :id, :pivt_id, :current_state
  
  def self.all
    query = {:filter => "mywork:#{Pivt::Client.name}"}
    response = Pivt::Client.get("stories", {:query => query})

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
    body = {
      :story => {
        :name => attributes[:name],
        :description => attributes[:description],
        :estimate => attributes[:estimate],
        :story_type => attributes[:type] || 'feature',
        :current_state => ( attributes[:open] ? 'started' : 'unstarted' ),
        :owned_by => Pivt::Client.name
      }
    }.pivt_xml

    response = Pivt::Client.post("stories", {:body => body})
    self.new(response['story'])
  end

  def initialize(attributes={}, options={})
    set_attributes(attributes)
    @pivt_id = options[:pivt_id]
  end

  def set_attributes(attributes={})
    @id = attributes['id']
    @name = attributes['name']
    @description = attributes['description']
    @current_state = attributes['current_state']
    @owned_by = attributes['owned_by']
    @requested_by = attributes['requested_by']
    @labels = attributes['labels']
  end

  def update(attributes={})
    body = {:story => attributes}.pivt_xml
    response = Pivt::Client.put("stories/#{@id}", {:body => body})

    set_attributes(response['story'])
    self
  end

  def delete
    response = Pivt::Client.delete("stories/#{@id}")
  end

  def format
    string = ''
    if @current_state == 'started'
      string += ("\n" + "  #{@pivt_id}. #{@name}".color(:green) + "\n")

      unless @description.nil?
        if @description.length < 72
          string += ("      " + @description + "\n")
        else
          @description.scan(/.{72}/).each do |output|
            string += ("      " + output + "\n")
          end
        end
      end
    elsif @current_state == 'unstarted'
      string += "  #{@pivt_id}. #{@name}\n"
    end
    string
  end

  def move id
    params = "moves?move\[move\]=before&move\[target\]=#{Pivt::Tasks.find(id).id}"
    headers = {'Content-length' => '0'}
    response = Pivt::Client.post("stories/#{@id}/#{params}", {:headers => headers})

    set_attributes(response['story'])
  end

  def pop
    if @pivt_id != 0
      move(@pivt_id - 1)
    end
  end

  def push
    # TODO: This needs work for the bottom edge
    move(@pivt_id + 2)
  end

  def estimate(score)
    update(:estimate => score)
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