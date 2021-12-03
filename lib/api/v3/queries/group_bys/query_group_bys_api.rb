

module API
  module V3
    module Queries
      module GroupBys
        class QueryGroupBysAPI < ::API::ProyeksiAppAPI
          resource :group_bys do
            helpers do
              def convert_to_ar(attribute)
                ::API::Utilities::WpPropertyNameConverter.to_ar_name(attribute)
              end
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            route_param :id, type: String, regexp: /\A\w+\z/, desc: 'Group by ID' do
              get do
                ar_id = convert_to_ar(params[:id]).to_sym
                column = Query.groupable_columns.detect { |candidate| candidate.name == ar_id }

                if column
                  ::API::V3::Queries::GroupBys::QueryGroupByRepresenter.new(column)
                else
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
