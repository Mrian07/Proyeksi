#-- encoding: UTF-8



namespace :ldap_groups do
  desc 'Synchronize groups and their users from the LDAP auth source.' \
       'Will only synchronize for those users already present in the application.'
  task synchronize: :environment do
    ::LdapGroups::SynchronizationService.synchronize!
  end

  namespace :development do
    desc 'Create a development LDAP server from the fixtures LDIF'
    task :ldap_server do
      require 'ladle'
      ldif = ENV['LDIF_FILE'] || Rails.root.join('spec/fixtures/ldap/users.ldif')
      ldap_server = Ladle::Server.new(quiet: false, port: '12389', domain: 'dc=example,dc=com', ldif: ldif).start

      puts <<~EOS
                #{'        '}
                        LDAP server ready at localhost:12389
                        Users Base dn: ou=people,dc=example,dc=com
                        Admin account: uid=admin,ou=system
                        Admin password: secret
        #{'        '}
                        --------------------------------------------------------
        #{'        '}
                        Attributes
                        Login: uid
                        First name: givenName
                        Last name: sn
                        Email: mail
                        memberOf: (Hard-coded, not virtual)
        #{'        '}
                        --------------------------------------------------------
                #{'          '}
                        Users:
                        uid=aa729,ou=people,dc=example,dc=com (Password: smada)
                        uid=bb459,ou=people,dc=example,dc=com (Password: niwdlab)
                        uid=cc414,ou=people,dc=example,dc=com (Password: retneprac)
        #{'        '}
                        --------------------------------------------------------
        #{'        '}
                        Groups:
                        cn=foo,ou=groups,dc=example,dc=com (Members: aa729)
                        cn=bar,ou=groups,dc=example,dc=com (Members: aa729, bb459, cc414)
      EOS

      puts "Send CTRL+D to stop the server"
      require 'irb'; binding.irb

      ldap_server.stop
    end
  end
end
