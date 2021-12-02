module ProyeksiApp
  module LdapGroups
    require "proyeksi_app/ldap_groups/engine"

    class << self
      def settings
        Setting.plugin_proyeksiapp_ldap_groups
      end

      def group_dn(value)
        "#{settings[:group_key]}=#{value},#{settings[:group_base]}"
      end
    end
  end
end
