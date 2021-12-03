

module API
  module V3
    module Projects
      module Copy
        class CreateFormAPI < ::API::ProyeksiAppAPI
          resource :form do
            post &::API::V3::Utilities::Endpoints::CreateForm
              .new(
                model: Project,
                instance_generator: ->(*) { @project },
                process_state: ->(params:, **) do
                  params.slice(:only, :send_notifications)
                end,
                parse_service: ParseCopyParamsService,
                process_service: ::Projects::CopyService,
                process_contract: ::Projects::CopyContract,
                parse_representer: ProjectCopyPayloadRepresenter,
                render_representer: CreateFormRepresenter
              )
              .mount
          end
        end
      end
    end
  end
end
