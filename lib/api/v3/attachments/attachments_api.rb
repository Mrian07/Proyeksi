require 'api/v3/attachments/attachment_representer'

module API
  module V3
    module Attachments
      class AttachmentsAPI < ::API::ProyeksiAppAPI
        resources :attachments do
          helpers API::V3::Attachments::AttachmentsByContainerAPI::Helpers

          helpers do
            def container
              nil
            end
          end

          post &API::V3::Attachments::AttachmentsByContainerAPI.create

          namespace :prepare do
            post &API::V3::Attachments::AttachmentsByContainerAPI.prepare
          end

          route_param :id, type: Integer, desc: 'Attachment ID' do
            after_validation do
              @attachment = Attachment.find(params[:id])

              raise ::API::Errors::NotFound.new unless @attachment.visible?(current_user)
            end

            get do
              AttachmentRepresenter.new(@attachment, embed_links: true, current_user: current_user)
            end

            delete &::API::V3::Utilities::Endpoints::Delete.new(model: Attachment).mount

            namespace :content, &::API::Helpers::AttachmentRenderer.content_endpoint(&-> {
              @attachment
            })

            namespace :uploaded do
              get do
                attachment = Attachment.pending_direct_upload.find(params[:id])

                raise API::Errors::NotFound unless attachment.file.readable?

                ::Attachments::FinishDirectUploadJob.perform_later attachment.id

                ::API::V3::Attachments::AttachmentRepresenter.new(attachment, current_user: current_user)
              end
            end
          end
        end
      end
    end
  end
end
