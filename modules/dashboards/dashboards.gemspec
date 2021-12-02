# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "dashboards"
  s.version     = '1.0.0'
  s.authors     = ["ProyeksiApp"]
  s.summary     = "ProyeksiApp Dashboards"

  s.files = Dir["{app,config,db,lib}/**/*"]

  s.add_dependency 'grids'
end
