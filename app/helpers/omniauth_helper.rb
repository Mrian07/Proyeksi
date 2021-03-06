#-- encoding: UTF-8

module OmniauthHelper
  def omniauth_direct_login?
    direct_login_provider.is_a? String
  end

  ##
  # Per default the user may choose the usual password login as well as several omniauth providers
  # on the login page and in the login drop down menu.
  #
  # With his configuration option you can set a specific omniauth provider to be
  # used for direct login. Meaning that the login provider selection is skipped and
  # the configured provider is used directly instead.
  #
  # If this option is active /login will lead directly to the configured omniauth provider
  # and so will a click on 'Sign in' (as opposed to opening the drop down menu).
  def direct_login_provider
    ProyeksiApp::Configuration['omniauth_direct_login_provider']
  end
end
