

module API
  module V3
    module Documents
      class DocumentRepresenter < ::API::Decorators::Single
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        cached_representer key_parts: %i(project),
                           disabled: false

        self_link title_getter: ->(*) { represented.title }

        property :id

        property :title

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

        def _type
          'Document'
        end
      end
    end
  end
end
