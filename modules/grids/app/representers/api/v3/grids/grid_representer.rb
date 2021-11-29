

module API
  module V3
    module Grids
      class GridRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        cached_representer key_parts: %i(widgets)

        resource_link :scope,
                      getter: ->(*) {
                        path = scope_path

                        next unless path

                        {
                          href: path,
                          type: 'text/html'
                        }
                      },
                      setter: ->(fragment:, **) {
                        represented.scope = fragment['href']
                      }

        self_link title_getter: ->(*) { nil }

        link :updateImmediately,
             cache_if: -> { write_allowed? } do
          {
            href: api_v3_paths.grid(represented.id),
            method: :patch
          }
        end

        link :update,
             cache_if: -> { write_allowed? } do
          {
            href: api_v3_paths.grid_form(represented.id),
            method: :post
          }
        end

        link :delete,
             cache_if: -> { delete_allowed? } do
          {
            href: api_v3_paths.grid(represented.id),
            method: :delete
          }
        end

        property :id

        property :name, render_nil: false

        property :row_count

        property :column_count

        property :options

        property :widgets,
                 exec_context: :decorator,
                 getter: ->(*) do
                   represented.widgets.sort_by { |w| w.id.to_i }.map do |widget|
                     Widgets::WidgetRepresenter.new(widget, current_user: current_user)
                   end
                 end,
                 setter: ->(fragment:, **) do
                   represented.widgets = fragment.map do |widget_fragment|
                     Widgets::WidgetRepresenter
                       .new(::Grids::Widget.new, current_user: current_user)
                       .from_hash(widget_fragment.with_indifferent_access)
                   end
                 end

        date_time_property :created_at,
                           writeable: false,
                           render_nil: false

        date_time_property :updated_at,
                           writeable: false,
                           render_nil: false

        def _type
          'Grid'
        end

        private

        def delete_allowed?
          represented.user_deletable? && write_allowed?
        end

        def write_allowed?
          !represented.new_record? &&
            ::Grids::Configuration.writable?(represented, current_user)
        end

        def scope_path
          path = ::Grids::Configuration.to_scope(represented.class,
                                                 scope_path_attributes)

          # Remove all query params
          # Those are added when the path does not actually require
          # project or user
          path&.gsub(/(\?.+)|(\.\d+)\z/, '')
        end

        def scope_path_attributes
          path_attributes = []

          if represented.respond_to?(:project)
            path_attributes << represented.project
          end

          if represented.respond_to?(:user)
            path_attributes << represented.user
          end

          path_attributes.compact
        end
      end
    end
  end
end
