# encoding: UTF-8

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "proyeksiapp-bim"
  s.version     = "1.0.0"
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.homepage    = "https://community.proyeksiapp.org/"
  s.summary     = "ProyeksiApp BIM and BCF functionality"
  s.description = "This ProyeksiApp plugin introduces BIM and BCF functionality"

  s.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'activerecord-import'
  s.add_dependency 'rubyzip', '~> 2.3.0'
end
