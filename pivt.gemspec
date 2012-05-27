# Ensure we require the local version and not one we might have installed already
#require File.join([File.dirname(__FILE__),'lib','pivt.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'pivt'
  s.version = '0.0.1 '#Pivt::VERSION
  s.author = 'Andrew Terris'
  s.email = 'atterris@gmail.com'
  s.homepage = 'http://andrewterris.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Pivotal Tracker CLI for getting shit done'
# Add your other files here if you make them
  s.files = %w(
bin/pivt
lib/pivt.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','pivt.rdoc']
  s.rdoc_options << '--title' << 'pivt' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'pivt'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
end
