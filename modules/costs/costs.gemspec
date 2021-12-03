# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'costs'
  s.version     = '1.0.0'
  s.authors = 'ProyeksiApp GmbH'
  s.email = 'info@proyeksiapp.com'
  s.summary     = 'ProyeksiApp Costs'
  s.description = 'This module adds features for planning and tracking costs of projects.'
  s.license     = 'GPLv3'

  s.files = Dir['{app,config,db,lib,doc}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']
end
