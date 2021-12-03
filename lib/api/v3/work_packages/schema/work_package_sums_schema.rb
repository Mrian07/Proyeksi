#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      module Schema
        class WorkPackageSumsSchema < BaseWorkPackageSchema
          def available_custom_fields
            WorkPackageCustomField.summable
          end

          def writable?(_property)
            false
          end
        end
      end
    end
  end
end
