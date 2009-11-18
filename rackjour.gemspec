Gem::Specification.new do |s|
  s.name = %q{rackjour}
  s.version = '0.1.9'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['David Turnbull']
  s.date = %q{2009-11-16}
  s.description = %q{Distribute your rack apps across the network with bonjour}
  s.email = %q{dsturnbull@gmail.com}
  s.files = ['Gemfile', 'lib', 'lib/rackjour', 'lib/rackjour/master.rb', 'lib/rackjour/server.rb', 'lib/rackjour/worker.rb', 'lib/rackjour.rb', 'rackjour.gemspec', 'Rakefile', 'bin/rackjour'] + Dir['vendor/gems/**/*']
  s.executables = ['rackjour']

  s.homepage = %q{http://github.com/dsturnbull/rackjour}
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Distribute your rack apps across the network with bonjour}
  s.test_files = ['spec/rackjour_worker_spec.rb', 'spec/spec_helper.rb']

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
