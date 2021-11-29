

module API
  module V3
    module Utilities
      module Endpoints
        class SqlIndex < Index
          private

          def render_paginated_success(results, query, params, self_path)
            resulting_params = calculate_resulting_params(query, params)

            ::API::V3::Utilities::SqlRepresenterWalker
              .new(results,
                   embed: { 'elements' => {} },
                   select: { '*' => {}, 'elements' => { '*' => {} } },
                   current_user: User.current,
                   self_path: self_path,
                   url_query: resulting_params)
              .walk(deduce_render_representer)
          end

          def paginated_representer?
            true
          end

          def deduce_render_representer
            "::API::V3::#{deduce_api_namespace}::#{api_name}SqlCollectionRepresenter".constantize
          end
        end
      end
    end
  end
end
