

require 'api/v3/attachments/attachment_collection_representer'

module API
  module V3
    module Attachments
      class AttachmentsByWorkPackageAPI < ::API::OpenProjectAPI
        resources :attachments do
          helpers API::V3::Attachments::AttachmentsByContainerAPI::Helpers

          helpers do
            def container
              @work_package
            end

            def get_attachment_self_path
              api_v3_paths.attachments_by_work_package(container.id)
            end
          end

          get &API::V3::Attachments::AttachmentsByContainerAPI.read

          # while attachments are #addable? when the user has the :add_work_packages permission or
          # the :edit_work_packages permission, we cannot differentiate here between adding to a newly
          # created work package (for which :add_work_package would be required) and adding to an older
          # work package (for which :edit_work_packages would be required). We thus only allow
          # :edit_work_packages in this endpoint and require clients to upload uncontainered work packages
          # first and attach them on wp creation.
          post &API::V3::Attachments::AttachmentsByContainerAPI.create([:edit_work_packages])

          namespace :prepare do
            post &API::V3::Attachments::AttachmentsByContainerAPI.prepare([:edit_work_packages])
          end
        end
      end
    end
  end
end
