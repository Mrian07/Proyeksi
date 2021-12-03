module ProyeksiApp::LdapGroups
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_ldap_groups

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-ldap_groups',
             author_url: 'https://github.com/opf/proyeksiapp-ldap_groups',
             bundled: true,
             settings: {
               default: {
                 name_attribute: 'cn'
               }
             } do
      menu :admin_menu,
           :plugin_ldap_groups,
           { controller: '/ldap_groups/synchronized_groups', action: :index },
           parent: :authentication,
           last: true,
           caption: ->(*) { I18n.t('ldap_groups.label_menu_item') }
    end

    add_cron_jobs { LdapGroups::SynchronizationJob }

    patches %i[AuthSource Group User]
  end
end
