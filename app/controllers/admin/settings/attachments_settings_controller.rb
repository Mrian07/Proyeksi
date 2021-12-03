#-- encoding: UTF-8

module Admin::Settings
  class AttachmentsSettingsController < ::Admin::SettingsController
    menu_item :settings_attachments

    def default_breadcrumb
      t(:'attributes.attachments')
    end

    private

    def settings_params
      super.tap do |settings|
        settings["attachment_whitelist"] = settings["attachment_whitelist"].split(/\r?\n/)
      end
    end
  end
end
