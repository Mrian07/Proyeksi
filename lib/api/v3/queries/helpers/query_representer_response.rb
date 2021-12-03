module API
  module V3
    module Queries
      module Helpers
        module QueryRepresenterResponse
          def query_representer_response(query, params, valid_subset = false)
            representer = ::API::V3::WorkPackageCollectionFromQueryService
                            .new(query, current_user)
                            .call(params, valid_subset: valid_subset)

            if representer.success?
              QueryRepresenter.new(query,
                                   current_user: current_user,
                                   results: representer.result,
                                   embed_links: true,
                                   params: params)
            else
              raise ::API::Errors::InvalidQuery.new(representer.errors.full_messages)
            end
          end
        end
      end
    end
  end
end
