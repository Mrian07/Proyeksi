

require 'support/pages/page'

require_relative 'form'

module Pages
  module Admin
    module CustomActions
      class Edit < Form
        attr_reader :custom_action

        def initialize(action)
          @custom_action = action
        end

        def path
          edit_custom_action_path(id: custom_action.id)
        end

        def save
          sleep 2
          click_button 'Save'
        end
      end
    end
  end
end
