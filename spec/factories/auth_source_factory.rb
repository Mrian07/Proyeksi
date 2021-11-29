

FactoryBot.define do
  factory :auth_source do
    name { 'Test AuthSource' }
  end
  factory :ldap_auth_source, class: 'LdapAuthSource' do
    name { 'Test LDAP AuthSource' }
    host { '127.0.0.1' }
    port { 225 }  # a reserved port, should not be in use
    attr_login { 'uid' }
  end

  factory :dummy_auth_source, class: 'DummyAuthSource' do
    name { 'DerpLAP' }
  end
end
