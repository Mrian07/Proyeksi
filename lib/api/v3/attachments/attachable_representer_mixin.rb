#-- encoding: UTF-8



module API
  module V3
    module Attachments
      module AttachableRepresenterMixin
        extend ActiveSupport::Concern

        cattr_accessor :attachments_by_link

        included do
          link :attachments do
            {
              href: attachments_by_resource
            }
          end

          link :prepareAttachment do
            next unless OpenProject::Configuration.direct_uploads?

            # We may not generate this link for new resources
            next if represented.new_record?

            {
              href: attachments_by_resource + '/prepare',
              method: :post
            }
          end

          link :addAttachment,
               cache_if: -> do
                 represented.attachments_addable?(current_user)
               end do
            {
              href: attachments_by_resource,
              method: :post
            }
          end

          property :attachments,
                   embedded: true,
                   exec_context: :decorator,
                   if: ->(*) { embed_links },
                   uncacheable: true

          def attachments
            ::API::V3::Attachments::AttachmentCollectionRepresenter.new(attachment_set,
                                                                        self_link: attachments_by_resource,
                                                                        current_user: current_user)
          end

          def attachments_by_resource
            path = "attachments_by_#{_type.singularize.underscore}"

            api_v3_paths.send(path, represented.id)
          end

          def attachment_set
            # Depending on the way attachments are handled we have three different cases:
            # * The attachments are replaced completely (but are not yet persisted)
            # * Additional attachments will be added to the container (but are not yet persisted)
            # * We only have the already persisted attachments
            #
            # The first two cases can happen e.g., when new and coming back from backend with an error.
            if represented.attachments_replacements
              represented.attachments_replacements
            elsif represented.attachments_claimed
              represented.attachments.concat(represented.attachments_claimed)
            else
              represented.attachments
            end
          end
        end
      end
    end
  end
end
