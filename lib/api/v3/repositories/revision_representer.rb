#-- encoding: UTF-8

module API
  module V3
    module Repositories
      class RevisionRepresenter < ::API::Decorators::Single
        include API::V3::Utilities
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty

        self_link path: :revision,
                  title_getter: ->(*) { nil }

        link :project do
          {
            href: api_v3_paths.project(represented.project.id),
            title: represented.project.name
          }
        end

        link :author do
          next if represented.user.nil?

          {
            href: api_v3_paths.user(represented.user.id),
            title: represented.user.name
          }
        end

        link :showRevision do
          {
            href: api_v3_paths.show_revision(represented.project.identifier,
                                             represented.identifier)
          }
        end

        property :id
        property :identifier
        property :format_identifier, as: :formattedIdentifier
        property :author, as: :authorName

        formattable_property :comments,
                             as: :message,
                             plain: true

        date_time_property :committed_on,
                           as: 'createdAt'

        def _type
          'Revision'
        end
      end
    end
  end
end
