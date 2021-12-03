module API
  module V3
    module Queries
      module Filters
        class QueryFiltersAPI < ::API::ProyeksiAppAPI
          resource :filters do
            helpers do
              def convert_to_ar(attribute)
                ::API::Utilities::QueryFiltersNameConverter.to_ar_name(attribute,
                                                                       refer_to_ids: true)
              end
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            route_param :id, type: String, regexp: /\A\w+\z/, desc: 'Filter ID' do
              get do
                ar_id = convert_to_ar(params[:id])
                filter_class = Query.find_registered_filter(ar_id)

                raise API::Errors::NotFound unless filter_class

                begin
                  filter = filter_class.create! name: ar_id
                  ::API::V3::Queries::Filters::QueryFilterRepresenter.new(filter)
                rescue ::Queries::Filters::InvalidError
                  Rails.logger.error "Failed to instantiate filter #{ar_id} through API"
                  raise API::Errors::NotFound
                end
              end
            end
          end
        end
      end
    end
  end
end
