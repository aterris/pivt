require 'aruba/cucumber'
require 'cucumber/rspec/doubles'
#require 'webmock/cucumber'
require 'fileutils'
require 'httparty'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
ENV['GLI_DEBUG'] = 'true'


Before do
  @stories = YAML.load_file('spec/fixtures/stories.yaml')
  @story = YAML.load_file('spec/fixtures/story.yaml')
end

After do
end