#-- encoding: UTF-8

module StandardSeeder
  module BasicData
    class TypeSeeder < ::BasicData::TypeSeeder
      def type_names
        %i[task milestone phase feature epic user_story bug]
      end

      def type_table
        { # position is_default color_id is_in_roadmap is_milestone
          task: [1, true, I18n.t(:default_color_blue), true, false, :default_type_task],
          milestone: [2, true, I18n.t(:default_color_green_light), false, true, :default_type_milestone],
          phase: [3, true, 'orange-5', false, false, :default_type_phase],
          feature: [4, false, 'indigo-5', true, false, :default_type_feature],
          epic: [5, false, 'violet-5', true, false, :default_type_epic],
          user_story: [6, false, I18n.t(:default_color_blue_light), true, false, :default_type_user_story],
          bug: [7, false, 'red-7', true, false, :default_type_bug]
        }
      end
    end
  end
end
