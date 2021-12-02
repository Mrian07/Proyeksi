# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-github_integration"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.homepage    = "https://docs.proyeksiapp.org/system-admin-guide/github-integration/"
  s.summary     = 'ProyeksiApp Github Integration'
  s.description = 'Integrates ProyeksiApp and Github for a better workflow'
  s.license     = 'GPLv3'

  s.files = Dir["{app,config,db,frontend,lib}/**/*"] + %w(README.md)

  s.add_dependency "proyeksiapp-webhooks"
end
