#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      module Schema
        class SpecificWorkPackageSchema < BaseWorkPackageSchema
          attr_reader :work_package

          include AssignableCustomFieldValues
          include AssignableValuesContract

          def initialize(work_package:)
            @work_package = work_package
          end

          delegate :project_id,
                   :project,
                   :type,
                   :id,
                   :milestone?,
                   :available_custom_fields,
                   to: :@work_package

          delegate :assignable_types,
                   :assignable_statuses,
                   :assignable_categories,
                   :assignable_priorities,
                   :assignable_versions,
                   :assignable_budgets,
                   to: :contract

          def no_caching?
            true
          end

          private

          def contract
            @contract ||= contract_class(work_package).new(work_package, User.current)
          end

          def contract_class(work_package)
            if work_package.new_record?
              ::WorkPackages::CreateContract
            else
              ::WorkPackages::UpdateContract
            end
          end
        end
      end
    end
  end
end
