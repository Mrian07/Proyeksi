

module API
  module V3
    module Attachments
      class AttachmentsByMeetingContentAPI < ::API::ProyeksiAppAPI
        resources :attachments do
          helpers API::V3::Attachments::AttachmentsByContainerAPI::Helpers

          helpers do
            def container
              meeting_content
            end

            def get_attachment_self_path
              api_v3_paths.attachments_by_meeting_content container.id
            end
          end

          get &API::V3::Attachments::AttachmentsByContainerAPI.read
          post &API::V3::Attachments::AttachmentsByContainerAPI.create

          namespace :prepare do
            post &API::V3::Attachments::AttachmentsByContainerAPI.prepare
          end
        end
      end
    end
  end
end
