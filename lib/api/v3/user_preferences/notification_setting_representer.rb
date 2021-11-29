#-- encoding: UTF-8



module API
  module V3
    module UserPreferences
      class NotificationSettingRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource

        NotificationSetting.all_settings.each do |setting|
          property setting
        end

        associated_resource :project,
                            skip_render: ->(*) { true },
                            skip_link: ->(*) { false }
      end
    end
  end
end
