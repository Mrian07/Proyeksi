

module ProyeksiApp
  module Hooks
    ##
    # Hook called in the login forms which displays the different auth providers
    class ViewAccountLoginAuthProvider < ProyeksiApp::Hook::ViewListener
      render_on :view_account_login_auth_provider,
                partial: 'hooks/login/auth_provider'
    end
  end
end
