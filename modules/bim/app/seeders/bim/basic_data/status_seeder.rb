#-- encoding: UTF-8


module Bim
  module BasicData
    class StatusSeeder < ::BasicData::StatusSeeder
      def data
        color_names = [
          'blue-6', # new
          'orange-6', # in progress
          'green-3', # resolved
          'gray-3' # closed
        ]

        # When selecting for an array of values, implicit order is applied
        # so we need to restore values by their name.
        colors_by_name = Color.where(name: color_names).index_by(&:name)
        colors = color_names.collect { |name| colors_by_name[name].id }

        [
          { name: I18n.t(:default_status_new),              color_id: colors[0],  is_closed: false, is_default: true,
            position: 1 },
          { name: I18n.t(:default_status_in_progress),      color_id: colors[1],  is_closed: false, is_default: false,
            position: 2 },
          { name: I18n.t('seeders.bim.default_status_resolved'), color_id: colors[2], is_closed: false,
            is_default: false, position: 3 },
          { name: I18n.t(:default_status_closed), color_id: colors[3], is_closed: true, is_default: false,
            position: 4 }
        ]
      end
    end
  end
end
