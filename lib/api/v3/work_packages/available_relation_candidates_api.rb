

module API
  module V3
    module WorkPackages
      class AvailableRelationCandidatesAPI < ::API::OpenProjectAPI
        helpers do
          def combined_params
            { filters: filters_param, pageSize: params[:pageSize] }.with_indifferent_access
          end

          def filters_param
            JSON::parse(params[:filters] || '[]')
              .concat([string_filter, type_filter])
          end

          def string_filter
            filter_param(:typeahead, '**', params[:query])
          end

          def type_filter
            filter_param(:relatable, params[:type], [@work_package.id.to_s])
          end

          def filter_param(key, operator, values)
            { key => { operator: operator, values: values } }.with_indifferent_access
          end
        end

        resources :available_relation_candidates do
          params do
            requires :query, type: String # part of the WP ID and/or part of its subject and/or part of the projects name
            optional :type, type: String, default: ::Relation::TYPE_RELATES # relation type
            optional :pageSize, type: Integer, default: 10
          end

          get do
            service = WorkPackageCollectionFromQueryParamsService
                      .new(current_user)
                      .call(combined_params)

            if service.success?
              service.result
            else
              api_errors = service.errors.full_messages.map do |message|
                ::API::Errors::InvalidQuery.new(message)
              end

              raise ::API::Errors::MultipleErrors.create_if_many api_errors
            end
          end
        end
      end
    end
  end
end
