#-- encoding: UTF-8



module Admin::Settings
  class IncomingMailsSettingsController < ::Admin::SettingsController
    current_menu_item [:show] do
      :incoming_mails
    end

    def default_breadcrumb
      t(:label_incoming_emails)
    end

    def show_local_breadcrumb
      true
    end
  end
end
