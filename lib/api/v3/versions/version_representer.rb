#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Versions
      class VersionRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include ::API::Caching::CachedRepresenter
        extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass

        cached_representer key_parts: %i(project)

        self_link

        link :schema do
          {
            href: api_v3_paths.version_schema
          }
        end

        link :update,
             cache_if: -> { current_user_allowed_to(:manage_versions, context: represented.project) } do
          {
            href: api_v3_paths.version_form(represented.id),
            method: :post
          }
        end

        link :updateImmediately,
             cache_if: -> { current_user_allowed_to(:manage_versions, context: represented.project) } do
          {
            href: api_v3_paths.version(represented.id),
            method: :patch
          }
        end

        link :delete,
             cache_if: -> { current_user_allowed_to(:manage_versions, context: represented.project) } do
          {
            href: api_v3_paths.version(represented.id),
            method: :delete
          }
        end

        associated_resource :project,
                            as: :definingProject,
                            skip_render: ->(*) { !represented.project || !represented.project.visible?(current_user) }

        link :availableInProjects do
          {
            href: api_v3_paths.projects_by_version(represented.id)
          }
        end

        property :id,
                 render_nil: true

        property :name,
                 render_nil: true

        formattable_property :description,
                             plain: true

        date_property :start_date

        date_property :effective_date,
                      as: 'endDate',
                      writeable: true

        property :status

        property :sharing

        date_time_property :created_at
        date_time_property :updated_at

        def _type
          'Version'
        end
      end
    end
  end
end
