module API
  module V3
    module Principals
      class PrincipalsAPI < ::API::ProyeksiAppAPI
        helpers ::API::Utilities::PageSizeHelper

        resource :principals do
          get do
            query = ParamsToQueryService.new(Principal, current_user).call(params)

            if query.valid?
              principals = query
                             .results
                             .where(id: Principal.visible(current_user))
                             .includes(:preference)

              ::API::V3::Users::PaginatedUserCollectionRepresenter.new(principals,
                                                                       self_link: api_v3_paths.principals,
                                                                       page: to_i_or_nil(params[:offset]),
                                                                       per_page: resolve_page_size(params[:pageSize]),
                                                                       current_user: current_user)
            else
              raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
            end
          end
        end
      end
    end
  end
end
