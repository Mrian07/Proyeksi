

require 'api/v3/attachments/attachment_collection_representer'

module API
  module V3
    module Attachments
      module AttachmentsByContainerAPI
        module Helpers
          # Global helper to set allowed content_types
          # This may be overridden when multipart is allowed (file uploads)
          def allowed_content_types
            if post_request?
              %w(multipart/form-data)
            else
              super
            end
          end

          def post_request?
            request.env['REQUEST_METHOD'] == 'POST'
          end

          ##
          # Additionally to what would be checked by the contract,
          # we need to restrict permissions in some use cases of the mounts of this endpoint.
          def restrict_permissions(permissions)
            authorize_any(permissions, projects: container.project) unless permissions.empty?
          end
        end

        def self.parse_multipart(request)
          request.params.tap do |params|
            params[:metadata] = JSON.parse(params[:metadata]) if params.key?(:metadata)
          end
        rescue JSON::ParserError
          raise ::API::Errors::InvalidRequestBody.new(I18n.t('api_v3.errors.invalid_json'))
        end

        def self.read
          -> do
            attachments = container.attachments
            AttachmentCollectionRepresenter.new(attachments,
                                                self_link: get_attachment_self_path,
                                                current_user: current_user)
          end
        end

        def self.create(permissions = [])
          ::API::V3::Utilities::Endpoints::Create
            .new(model: ::Attachment,
                 parse_representer: AttachmentParsingRepresenter,
                 params_source: method(:parse_multipart),
                 before_hook: ->(request:) { request.restrict_permissions(permissions) },
                 params_modifier: ->(params) do
                   params.merge(container: container)
                 end)
            .mount
        end

        def self.prepare(permissions = [])
          ::API::V3::Utilities::Endpoints::Create
            .new(model: ::Attachment,
                 parse_representer: AttachmentParsingRepresenter,
                 render_representer: AttachmentUploadRepresenter,
                 process_service: ::Attachments::PrepareUploadService,
                 process_contract: ::Attachments::PrepareUploadContract,
                 params_source: method(:parse_multipart),
                 before_hook: ->(request:) { request.restrict_permissions(permissions) },
                 params_modifier: ->(params) do
                   params.merge(container: container)
                 end)
            .mount
        end
      end
    end
  end
end
