#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module EagerLoading
        class CustomAction < Base
          def apply(work_package)
            applicable_actions = custom_actions.select do |action|
              action.conditions_fulfilled?(work_package, User.current)
            end

            work_package.custom_actions = applicable_actions
          end

          def self.module
            CustomActionAccessor
          end

          private

          def custom_actions
            @custom_actions ||= ::CustomAction
                                .available_conditions
                                .inject(::CustomAction.all) do |scope, condition|
              scope.merge(condition.custom_action_scope(work_packages, User.current))
            end
          end

          module CustomActionAccessor
            extend ActiveSupport::Concern

            included do
              attr_writer :custom_actions

              # Hiding the work_package's own custom_actions method
              # to profit from the eager loaded actions
              def custom_actions(_user)
                @custom_actions
              end
            end
          end
        end
      end
    end
  end
end
