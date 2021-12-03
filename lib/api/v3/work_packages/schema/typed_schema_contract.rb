#-- encoding: UTF-8

# The contract is not actually used for validations but rather to display the unimbedded schema
# as the writable attributes differ depending on whether the user has the necessary permissions.
# As we do not know the context of the schema, other than when it is embedded inside a form, we have to allow
# both possible permissions.
module API
  module V3
    module WorkPackages
      module Schema
        class TypedSchemaContract < ::WorkPackages::BaseContract
          default_attribute_permission %i[edit_work_packages add_work_packages]
          attribute_permission :project_id, :move_work_packages
        end
      end
    end
  end
end
