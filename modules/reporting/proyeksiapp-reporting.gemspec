# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-reporting"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = "ProyeksiApp Reporting"
  s.description = "This plugin allows creating custom cost reports with filtering and grouping created by the ProyeksiApp Costs plugin"

  s.files       = Dir["{app,config,db,lib,doc}/**/*", "README.md"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "costs"
end
