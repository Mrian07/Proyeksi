#-- encoding: UTF-8



module API
  module V3
    module Attachments
      module AttachablePayloadRepresenterMixin
        extend ActiveSupport::Concern

        included do
          def writeable_attributes
            super + %w[attachments]
          end

          property :attachments,
                   exec_context: :decorator,
                   getter: ->(*) {},
                   setter: ->(fragment:, **) do
                     next unless fragment.is_a?(Array)

                     ids = fragment.map do |link|
                       ::API::Utilities::ResourceLinkParser.parse_id link['href'],
                                                                     property: :attachment,
                                                                     expected_version: '3',
                                                                     expected_namespace: :attachments
                     end

                     represented.attachment_ids = ids
                   end,
                   skip_render: ->(*) { true },
                   linked_resource: true,
                   uncacheable: true

          links :attachments do
            represented.attachments.map do |attachment|
              { href: api_v3_paths.attachment(attachment.id) }
            end
          end
        end
      end
    end
  end
end
