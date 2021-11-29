#-- encoding: UTF-8



module Admin::Settings
  class NotificationsSettingsController < ::Admin::SettingsController
    current_menu_item [:show] do
      :notification_settings
    end

    def show
      respond_to :html
    end

    def default_breadcrumb
      t(:'menus.admin.incoming_outgoing')
    end

    def show_local_breadcrumb
      true
    end
  end
end
