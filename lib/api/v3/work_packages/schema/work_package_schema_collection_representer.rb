#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module Schema
        class WorkPackageSchemaCollectionRepresenter <
          ::API::V3::Schemas::SchemaCollectionRepresenter
          private

          def model_self_link(model)
            api_v3_paths.work_package_schema(model.project.id,
                                             model.type.id)
          end
        end
      end
    end
  end
end
