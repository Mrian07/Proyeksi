module API
  module V3
    module Attachments
      class AttachmentsByPostAPI < ::API::ProyeksiAppAPI
        resources :attachments do
          helpers API::V3::Attachments::AttachmentsByContainerAPI::Helpers

          helpers do
            def container
              post
            end

            def get_attachment_self_path
              api_v3_paths.attachments_by_post(container.id)
            end
          end

          get &API::V3::Attachments::AttachmentsByContainerAPI.read
          post &API::V3::Attachments::AttachmentsByContainerAPI.create([:edit_messages])

          namespace :prepare do
            post &API::V3::Attachments::AttachmentsByContainerAPI.prepare([:edit_messages])
          end
        end
      end
    end
  end
end
