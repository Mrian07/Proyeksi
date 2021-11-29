

require 'support/pages/page'

require_relative 'form'

module Pages
  module Admin
    module CustomActions
      class New < Form
        def create
          sleep 2
          click_button 'Create'
        end

        def path
          new_custom_action_path
        end
      end
    end
  end
end
