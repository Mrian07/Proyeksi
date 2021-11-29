

module API
  module V3
    module Attachments
      class AttachmentsByHelpTextAPI < ::API::OpenProjectAPI
        resources :attachments do
          helpers API::V3::Attachments::AttachmentsByContainerAPI::Helpers

          helpers do
            def container
              @help_text
            end

            def get_attachment_self_path
              api_v3_paths.attachments_by_help_text(container.id)
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
