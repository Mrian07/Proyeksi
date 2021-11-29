

FactoryBot.define do
  factory :oauth_application, class: '::Doorkeeper::Application' do
    name { 'My API application' }
    confidential { true }
    owner factory: :admin
    owner_type { 'User' }
    uid { '12345' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    scopes { 'api_v3' }
  end
end
