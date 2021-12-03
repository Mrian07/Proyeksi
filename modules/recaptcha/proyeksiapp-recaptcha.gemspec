# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-recaptcha"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = "ProyeksiApp ReCaptcha"
  s.description = "This module provides recaptcha checks during login"

  s.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'recaptcha', '~> 5.7'
end
