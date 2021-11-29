#-- encoding: UTF-8



module API
  module V3
    module Projects
      module Copy
        class CreateFormRepresenter < FormRepresenter
          include API::Decorators::CreateForm

          def form_url
            api_v3_paths.project_copy_form(meta.source.id)
          end

          def resource_url
            api_v3_paths.project_copy(meta.source.id)
          end
        end
      end
    end
  end
end
