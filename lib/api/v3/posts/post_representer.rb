module API
  module V3
    module Posts
      class PostRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        self_link title_getter: ->(*) { nil }

        property :id

        property :subject

        associated_resource :project,
                            link: ->(*) do
                              {
                                href: api_v3_paths.project(represented.project.id),
                                title: represented.project.name
                              }
                            end

        def _type
          'Post'
        end
      end
    end
  end
end
