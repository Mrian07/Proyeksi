# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "overviews"
  s.version     = '1.0.0'
  s.authors     = ["ProyeksiApp"]
  s.summary     = "ProyeksiApp Project Overviews"

  s.files = Dir["{app,config,db,lib}/**/*"]

  s.add_dependency 'grids'
end
