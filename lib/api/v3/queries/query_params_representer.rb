#-- encoding: UTF-8

# Other than the Roar based representers of the api v3, this
# representer is only responsible for transforming a query's
# attributes into a hash which in turn can be used e.g. to be displayed
# in a url

module API
  module V3
    module Queries
      class QueryParamsRepresenter < API::Decorators::QueryParamsRepresenter
        ##
        # To json hash outputs the hash to be parsed to the frontend http
        # which contains a reference to the columns array as columns[].
        # This will match the Rails +to_query+ output
        def to_json(*_args)
          to_h(column_key: 'columns[]'.to_sym).to_json
        end

        ##
        # Output as query params used for directly using in URL queries.
        # Outputs columns[]=A,columns[]=B due to Rails query output.
        def to_url_query(merge_params: {})
          to_h
            .merge(merge_params.symbolize_keys)
            .to_query
        end

        def to_h(column_key: :columns)
          p = super

          p[:showHierarchies] = query.show_hierarchies
          p[:showSums] = query.display_sums?
          p[:groupBy] = query.group_by if query.group_by?
          p[column_key] = columns_to_v3 unless query.has_default_columns?

          p
        end

        def self_link
          if query.project
            api_v3_paths.work_packages_by_project(query.project.id)
          else
            api_v3_paths.work_packages
          end
        end

        private

        def orders_to_v3
          converted = query.sort_criteria.map { |first, last| [convert_to_v3(first), last] }

          JSON::dump(converted)
        end

        def columns_to_v3
          query.column_names.map { |name| convert_to_v3(name) }
        end

        attr_accessor :query
      end
    end
  end
end
