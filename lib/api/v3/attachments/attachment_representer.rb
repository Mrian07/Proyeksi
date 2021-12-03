#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Attachments
      class AttachmentRepresenter < ::API::Decorators::Single
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter

        self_link title_getter: ->(*) { represented.filename }

        associated_resource :author,
                            v3_path: :user,
                            representer: ::API::V3::Users::UserRepresenter

        cached_representer key_parts: %i[author container]

        def self.associated_container_getter
          ->(*) do
            next unless embed_links && container_representer

            container_representer
              .new(represented.container, current_user: current_user)
          end
        end

        def self.associated_container_link
          ->(*) do
            return nil unless v3_container_name == 'nil_class' || api_v3_paths.respond_to?(v3_container_name)

            ::API::Decorators::LinkObject
              .new(represented,
                   path: v3_container_name,
                   property_name: :container,
                   title_attribute: container_title_attribute)
              .to_hash
          end
        end

        associated_resource :container,
                            getter: associated_container_getter,
                            link: associated_container_link

        link :staticDownloadLocation do
          {
            href: api_v3_paths.attachment_content(represented.id)
          }
        end

        link :downloadLocation do
          location = if represented.external_storage?
                       represented.external_url
                     else
                       api_v3_paths.attachment_content(represented.id)
                     end
          {
            href: location
          }
        end

        link :delete,
             cache_if: -> { represented.deletable?(current_user) } do
          {
            href: api_v3_paths.attachment(represented.id),
            method: :delete
          }
        end

        property :id
        property :file_name,
                 getter: ->(*) { filename }
        property :file_size,
                 getter: ->(*) { filesize }

        formattable_property :description,
                             plain: true

        property :content_type
        property :digest,
                 getter: ->(*) {
                   ::API::Decorators::Digest.new(digest, algorithm: 'md5')
                 },
                 render_nil: true

        date_time_property :created_at

        def _type
          'Attachment'
        end

        def container_representer
          name = v3_container_name.camelcase

          "::API::V3::#{name.pluralize}::#{name}Representer".constantize
        rescue NameError
          nil
        end

        def v3_container_name
          ::API::Utilities::PropertyNameConverter.from_ar_name(represented.container.class.name.underscore).underscore
        end

        def container_title_attribute
          represented.container.respond_to?(:subject) ? :subject : :title
        end
      end
    end
  end
end
