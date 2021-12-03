module API
  module V3
    module News
      class NewsRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include API::Caching::CachedRepresenter

        cached_representer key_parts: %i(project author),
                           disabled: false

        self_link title_getter: ->(*) { represented.title }

        property :id

        property :title

        property :summary

        formattable_property :description

        date_time_property :created_at
        date_time_property :updated_at

        associated_resource :project,
                            link: ->(*) do
                              {
                                href: api_v3_paths.project(represented.project.id),
                                title: represented.project.name
                              }
                            end

        associated_resource :author,
                            v3_path: :user,
                            representer: ::API::V3::Users::UserRepresenter

        def _type
          'News'
        end
      end
    end
  end
end
