#-- encoding: UTF-8



module API
  module V3
    module Projects
      module Copy
        class FormRepresenter < ::API::V3::Projects::FormRepresenter
          include ::API::Decorators::MetaForm

          private

          def payload_representer_class
            ProjectCopyPayloadRepresenter
          end

          ##
          # Instantiate the copy schema with the source project
          # to correctly derive available modules and counts
          def schema_representer
            contract = contract_class.new(meta.source, current_user)

            ProjectCopySchemaRepresenter
              .create(contract,
                      form_embedded: true,
                      current_user: current_user)
          end

        end
      end
    end
  end
end
