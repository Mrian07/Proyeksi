# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-documents"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = "ProyeksiApp Documents"
  s.description = "An ProyeksiApp plugin to allow creation of documents in projects"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib,doc}/**/*", "README.md"]
  s.test_files = Dir["spec/**/*"]
end
