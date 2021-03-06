# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'proyeksiapp-backlogs'
  s.version     = '1.0.0'
  s.authors = 'ProyeksiApp GmbH'
  s.email = 'info@proyeksiapp.com'
  s.summary     = 'ProyeksiApp Backlogs'
  s.description = 'This module adds features enabling agile teams to work with ProyeksiApp in Scrum projects.'
  s.files = Dir['{app,config,db,lib,doc}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'acts_as_list', '~> 1.0.1'

  s.add_dependency 'proyeksiapp-pdf_export'

  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
end
