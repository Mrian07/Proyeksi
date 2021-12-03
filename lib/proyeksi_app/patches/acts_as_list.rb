

# This patch adds a convenience method to models that are including acts_as_list.
# After including it is possible to e.g. call
#
# including_instance.move_to = "highest"
#
# and the instance will be sorted to to the top of the list.
#
# This enables having the view send string that will be used for sorting.

# Needs to be applied before any of the models using acts_as_list get loaded.

module ProyeksiApp
  module Patches
    module ActsAsList
      def move_to=(pos)
        pos = pos.to_sym

        case pos
        when :highest
          move_to_top
        when :lowest
          move_to_bottom
        when :higher
          move_higher
        when :lower
          move_lower
        end
      end
    end
  end
end

ActiveRecord::Acts::List::InstanceMethods.include ProyeksiApp::Patches::ActsAsList
