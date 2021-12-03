# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-ldap_groups"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH, Oliver Günther"
  s.email       = "info@proyeksiapp.com"
  s.homepage    = "https://github.com/opf/proyeksiapp-ldap_groups"
  s.summary     = 'ProyeksiApp LDAP groups'
  s.description = 'Synchronization of LDAP group memberships'
  s.license     = 'GPL-3'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(README.md)
  s.add_development_dependency 'ladle'
end
