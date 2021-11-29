

module API
  module V3
    module WorkPackages
      module Schema
        module FormConfigurations
          class QueryRepresenter < ::API::Decorators::Single
            include API::Decorators::LinkedResource

            property :name,
                     exec_context: :decorator

            property :relation_type,
                     exec_context: :decorator

            associated_resource :query,
                                link: ->(*) do
                                  {
                                    href: api_v3_paths.query(query.id),
                                    title: query.name
                                  }
                                end,
                                getter: ->(*) do
                                  next unless embed_links

                                  ::API::V3::Queries::QueryRepresenter.new(query, current_user: current_user)
                                end

            def _type
              if relation_type == ::Relation::TYPE_HIERARCHY
                "WorkPackageFormChildrenQueryGroup"
              else
                "WorkPackageFormRelationQueryGroup"
              end
            end

            def relation_type
              relation_filter&.relation_type
            end

            def relation_filter
              @relation_filter ||= query.filters.detect { |f| f.respond_to? :relation_type }
            end

            def name
              represented.translated_key
            end

            def query
              represented.query
            end
          end
        end
      end
    end
  end
end
