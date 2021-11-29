#-- encoding: UTF-8



module API
  module V3
    module Queries
      module SortBys
        class QuerySortByRepresenter < ::API::Decorators::Single
          include API::Utilities::RepresenterToJsonCache

          self_link id_attribute: ->(*) { self_link_params },
                    title_getter: ->(*) { represented.name }

          def initialize(model, *_)
            super(model, current_user: nil, embed_links: true)
          end

          link :column do
            {
              href: api_v3_paths.query_column(represented.converted_name),
              title: represented.column_caption
            }
          end

          link :direction do
            {
              href: represented.direction_uri,
              title: represented.direction_l10n
            }
          end

          property :id

          property :name

          def self_link_params
            [represented.converted_name, represented.direction_name]
          end

          def _type
            'QuerySortBy'
          end

          def json_cache_key
            [represented.column_caption, represented.direction_name]
          end
        end
      end
    end
  end
end
