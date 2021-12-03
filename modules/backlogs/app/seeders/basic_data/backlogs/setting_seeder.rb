#-- encoding: UTF-8



module BasicData
  module Backlogs
    class SettingSeeder < ::Seeder
      def seed_data!
        backlogs_init_setting!
      end

      def applicable?
        not backlogs_configured?
      end

      module Functions
        module_function

        def backlogs_init_setting!
          Setting[backlogs_setting_name] = backlogs_setting_value
        end

        def backlogs_configured?
          setting = Hash(Setting[backlogs_setting_name])
          setting['story_types'].present? && setting['task_type'].present?
        end

        def backlogs_setting_name
          'plugin_proyeksiapp_backlogs'
        end

        def backlogs_setting_value
          {
            "story_types" => backlogs_types.map(&:id),
            "task_type" => backlogs_task_type.try(:id),
            "points_burn_direction" => "up",
            "wiki_template" => ""
          }
        end

        def backlogs_types
          Type.where(name: backlogs_type_names)
        end

        def backlogs_type_names
          %i[default_type_feature default_type_epic default_type_user_story default_type_bug]
            .map { |code| I18n.t(code) }
        end

        def backlogs_task_type
          Type.find_by(name: backlogs_task_type_name)
        end

        def backlogs_task_type_name
          I18n.t(:default_type_task)
        end
      end

      include Functions
    end
  end
end
