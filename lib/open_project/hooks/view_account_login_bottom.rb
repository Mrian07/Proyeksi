

module OpenProject
  module Hooks
    class ViewAccountLoginBottom < OpenProject::Hook::ViewListener
      render_on :view_account_login_bottom, partial: 'announcements/show'
    end
  end
end
