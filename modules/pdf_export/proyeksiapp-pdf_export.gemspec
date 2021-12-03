# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-pdf_export"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = 'ProyeksiApp PDF Export'
  s.description = "PDF Export Plugin"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib,doc}/**/*", "README.md"]

  s.add_dependency "pdf-inspector", "~> 1.3.0"
  s.add_dependency "prawn", "~> 2.2"
end
