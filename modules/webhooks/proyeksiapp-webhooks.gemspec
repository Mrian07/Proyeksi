# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-webhooks"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.homepage    = "https://github.com/opf/proyeksiapp-webhooks"
  s.summary     = 'ProyeksiApp Webhooks'
  s.description = 'Provides a plug-in API to support ProyeksiApp webhooks for better 3rd party integration'
  s.license     = 'GPLv3'

  s.files = Dir["{app,config,db,doc,lib}/**/*"] + %w(README.md)
end
