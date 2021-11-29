

require 'api/v3/queries/query_representer'

module API
  module V3
    module Queries
      module QueryHelper
        ##
        # @param query [Query]
        # @param contract [Class]
        # @param form_representer [Class]
        #
        # Additionally, two parameters are accepted under the hood.
        #
        # # request_body
        # # params
        #
        # Both are applied to the query in order to adapt it.
        def create_or_update_query_form(query, contract, form_representer)
          query = update_query_from_body_and_params(query)
          contract = contract.new query, current_user
          contract.validate

          query.user = current_user

          form_result query, form_representer, ::API::Errors::ErrorBase.create_errors(contract.errors)
        end

        def form_result(query, form_representer, api_errors)
          # errors for invalid data (e.g. validation errors) are handled inside the form
          if api_errors.all? { |error| error.code == 422 }
            status 200
            form_representer.new query, current_user: current_user, errors: api_errors
          else
            fail ::API::Errors::MultipleErrors.create_if_many(api_errors)
          end
        end

        def create_query(request_body, current_user)
          rep = representer.new Query.new, current_user: current_user
          query = rep.from_hash request_body
          call = ::Queries::CreateService.new(user: current_user).call query

          if call.success?
            representer.new call.result, current_user: current_user, embed_links: true
          else
            fail ::API::Errors::ErrorBase.create_and_merge_errors(call.errors)
          end
        end

        def update_query(query, request_body, current_user)
          rep = representer.new query, current_user: current_user
          query = rep.from_hash request_body
          call = ::Queries::UpdateService.new(user: current_user).call query

          if call.success?
            representer.new call.result, current_user: current_user, embed_links: true
          else
            fail ::API::Errors::ErrorBase.create_and_merge_errors(call.errors)
          end
        end

        def representer
          ::API::V3::Queries::QueryRepresenter
        end

        def update_query_from_get_params(query)
          query_params = ActionDispatch::Request.new(request.env).query_parameters

          if query_params.is_a?(Hash) && !query_params.empty?
            UpdateQueryFromV3ParamsService.new(query, current_user).call(query_params)
          end
        end

        def update_query_from_body_and_params(query)
          representer = ::API::V3::Queries::QueryRepresenter.create query, current_user: current_user

          # Update the query from the hash
          representer.from_hash(Hash(request_body)).tap do |parsed_query|
            # Note that we do not deal with failures here. The query
            # needs to be validated later.
            update_query_from_get_params parsed_query
          end
        end
      end
    end
  end
end
