# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "my_page"
  s.version     = '1.0.0'
  s.authors     = ["ProyeksiApp"]
  s.summary     = "ProyeksiApp MyPage."

  s.files = Dir["{app,config,db,lib}/**/*"]

  s.add_dependency 'grids'
end
