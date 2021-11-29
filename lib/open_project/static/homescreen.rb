#-- encoding: UTF-8



module OpenProject
  module Static
    module Homescreen
      class << self
        ##
        # Access a defined item on the homescreen
        # By default, this will likely be :blocks and :links,
        # however plugins may define their own blocks and
        # render them in the call_hook.
        def [](item)
          homescreen[item]
        end

        ##
        # Manage the given content for this item,
        # yielding it.
        def manage(item, default = [])
          homescreen[item] ||= default
          yield homescreen[item]
        end

        private

        def homescreen
          @content ||= {}
        end
      end
    end
  end
end
