#-- encoding: UTF-8



module WorkPackage::CustomActioned
  extend ActiveSupport::Concern

  included do
    def custom_actions(user)
      @custom_actions = CustomAction
                        .available_conditions
                        .inject(CustomAction.all) do |scope, condition|
        scope.merge(condition.custom_action_scope(self, user))
      end
    end
  end
end
