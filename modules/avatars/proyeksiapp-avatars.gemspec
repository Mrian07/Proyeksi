# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-avatars"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = 'ProyeksiApp Avatars'
  s.description = 'This plugin allows ProyeksiApp users to upload a picture to be used ' \
                  'as an avatar or use registered images from Gravatar.'
  s.license     = 'GPLv3'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(README.md)
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'fastimage', '~> 2.2.0'
  s.add_dependency 'gravatar_image_tag', '~> 1.2.0'
end
