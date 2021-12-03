# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'proyeksiapp-auth_plugins'
  s.version     = '1.0.0'
  s.authors     = 'ProyeksiApp GmbH'
  s.email       = 'info@proyeksiapp.com'
  s.summary     = 'ProyeksiApp Auth Plugins'
  s.description = 'Integration of OmniAuth strategy providers for authentication in Open-project.'
  s.license     = 'GPLv3'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(doc/CHANGELOG.md README.md)

  s.add_dependency 'omniauth', '~> 1.0'

  s.add_development_dependency 'rspec', '~> 2.14'
end
