#-- encoding: UTF-8



class LdapAuthSourcesController < AuthSourcesController
  menu_item :ldap_authentication

  protected

  def auth_source_class
    LdapAuthSource
  end
end
