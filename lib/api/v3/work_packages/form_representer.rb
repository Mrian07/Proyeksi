#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      class FormRepresenter < ::API::Decorators::Form
        def payload_representer
          WorkPackagePayloadRepresenter
            .create_class(represented, current_user)
            .new(represented, current_user: current_user)
        end

        def schema_representer
          schema = Schema::SpecificWorkPackageSchema.new(work_package: represented)
          schema_link = api_v3_paths.work_package_schema(represented.project_id,
                                                         represented.type_id)
          Schema::WorkPackageSchemaRepresenter.create(schema,
                                                      self_link: nil,
                                                      form_embedded: true,
                                                      base_schema_link: schema_link,
                                                      current_user: current_user)
        end
      end
    end
  end
end
