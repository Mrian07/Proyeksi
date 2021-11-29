#-- encoding: UTF-8



module Admin::Settings
  class MailNotificationsSettingsController < ::Admin::SettingsController
    current_menu_item [:show] do
      :mail_notifications
    end

    def show
      @deliveries = ActionMailer::Base.perform_deliveries

      respond_to :html
    end

    def default_breadcrumb
      t(:'menus.admin.mail_notification')
    end

    def show_local_breadcrumb
      true
    end
  end
end
