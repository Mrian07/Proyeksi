require 'api/v3/users/user_collection_representer'

module API
  module V3
    module Projects
      module Copy
        class CopyAPI < ::API::ProyeksiAppAPI
          resource :copy do
            after_validation do
              authorize(:copy_projects, context: @project)
            end

            mount ::API::V3::Projects::Copy::CreateFormAPI

            post &::API::V3::Utilities::Endpoints::DelayedModify
                    .new(
                      model: Project,
                      instance_generator: ->(*) { @project },
                      process_state: ->(params:, **) do
                        params.slice(:only, :send_notifications)
                      end,
                      parse_service: ParseCopyParamsService,
                      process_service: ::Projects::EnqueueCopyService,
                      process_contract: ::Projects::CopyContract,
                      parse_representer: ProjectCopyPayloadRepresenter
                    )
                    .mount
          end
        end
      end
    end
  end
end
