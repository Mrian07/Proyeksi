

module ProyeksiApp
  module Hooks
    class ViewAccountLoginBottom < ProyeksiApp::Hook::ViewListener
      render_on :view_account_login_bottom, partial: 'announcements/show'
    end
  end
end
