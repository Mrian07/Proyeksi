#-- encoding: UTF-8

module StandardSeeder
  module BasicData
    class ActivitySeeder < ::BasicData::ActivitySeeder
      def data
        [
          { name: I18n.t(:default_activity_management), position: 1, is_default: true },
          { name: I18n.t(:default_activity_specification), position: 2, is_default: false },
          { name: I18n.t(:default_activity_development), position: 3, is_default: false },
          { name: I18n.t(:default_activity_testing), position: 4, is_default: false },
          { name: I18n.t(:default_activity_support), position: 5, is_default: false },
          { name: I18n.t(:default_activity_other), position: 6, is_default: false }
        ]
      end
    end
  end
end
