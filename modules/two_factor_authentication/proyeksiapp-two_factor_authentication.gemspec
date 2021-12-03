# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "proyeksiapp-two_factor_authentication"
  s.version     = '1.0.0'
  s.authors     = "ProyeksiApp GmbH"
  s.email       = "info@proyeksiapp.com"
  s.summary     = "ProyeksiApp Two-factor authentication"
  s.description = "This ProyeksiApp plugin authenticates your users using two-factor authentication by means of one-time password " \
                  "through the TOTP standard (Google Authenticator) or sent to the user's cell phone via SMS or voice call"

  s.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'messagebird-rest', '~> 1.4.2'
  s.add_dependency 'rotp', '~> 6.1'

  s.add_dependency 'aws-sdk-sns', '~> 1.48.0'
end