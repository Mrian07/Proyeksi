#-- encoding: UTF-8



module API
  module V3
    module WikiPages
      class WikiPageRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        self_link title_getter: ->(*) { nil }

        property :id

        property :title

        associated_resource :project,
                            link: ->(*) do
                              next unless represented.project.present?

                              {
                                href: api_v3_paths.project(represented.project.id),
                                title: represented.project.name
                              }
                            end

        def _type
          'WikiPage'
        end
      end
    end
  end
end
