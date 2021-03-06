#-- encoding: UTF-8

module StandardSeeder
  module BasicData
    class PrioritySeeder < ::BasicData::PrioritySeeder
      def data
        color_names = [
          'cyan-1', # low
          'blue-3', # normal
          'yellow-7', # high
          'grape-5' # immediate
        ]

        # When selecting for an array of values, implicit order is applied
        # so we need to restore values by their name.
        colors_by_name = Color.where(name: color_names).index_by(&:name)
        colors = color_names.collect { |name| colors_by_name[name].id }

        [
          { name: I18n.t(:default_priority_low), color_id: colors[0], position: 1, is_default: false },
          { name: I18n.t(:default_priority_normal), color_id: colors[1], position: 2, is_default: true },
          { name: I18n.t(:default_priority_high), color_id: colors[2], position: 3, is_default: false },
          { name: I18n.t(:default_priority_immediate), color_id: colors[3], position: 4, is_default: false }
        ]
      end
    end
  end
end
