

module API
  module V3
    module Queries
      module Schemas
        class QueryFilterInstanceSchemaAPI < ::API::ProyeksiAppAPI
          resource :filter_instance_schemas do
            helpers do
              def collection_representer
                ::API::V3::Queries::Schemas::QueryFilterInstanceSchemaCollectionRepresenter
              end

              def single_representer
                ::API::V3::Queries::Schemas::QueryFilterInstanceSchemaRepresenter
              end
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            get do
              filters = Query.new.available_filters

              collection_representer.new(filters,
                                         self_link: api_v3_paths.query_filter_instance_schemas,
                                         current_user: current_user)
            end

            route_param :id, type: String, regexp: /\A\w+\z/, desc: 'Filter schema ID' do
              get do
                ar_name = ::API::Utilities::QueryFiltersNameConverter
                          .to_ar_name(params[:id], refer_to_ids: true)
                filter_class = Query.find_registered_filter(ar_name)

                raise ::API::Errors::NotFound.new if filter_class.nil?

                filter = filter_class.create! name: ar_name, context: OpenStruct.new(project: nil)

                single_representer.new(filter,
                                       self_link: api_v3_paths.query_filter_instance_schema(params[:id]),
                                       current_user: current_user)
              end
            end
          end
        end
      end
    end
  end
end
