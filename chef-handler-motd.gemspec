Gem::Specification.new do |s|
  s.name = 'chef-handler-motd'
  s.version = '0.3.0'
  s.author = 'Simple Finance'
  s.email = 'ops@simple.com'
  s.homepage = 'http://github.com/SimpleFinance/chef-handler-motd'
  s.summary = 'Edits MOTD at the end of a Chef run'
  s.description = 'Edits MOTD at the end of a Chef run'
  s.files = ::Dir.glob('**/*')
  s.require_paths = ['lib']
end

