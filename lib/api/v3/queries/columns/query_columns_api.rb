module API
  module V3
    module Queries
      module Columns
        class QueryColumnsAPI < ::API::ProyeksiAppAPI
          resource :columns do
            helpers do
              def convert_to_ar(attribute)
                ::API::Utilities::WpPropertyNameConverter.to_ar_name(attribute)
              end
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            route_param :id, type: String, regexp: /\A\w+\z/, desc: 'Column ID' do
              get do
                ar_id = convert_to_ar(params[:id]).to_sym
                column = Query.available_columns.detect { |candidate| candidate.name == ar_id }

                if column
                  QueryColumnsFactory.create(column)
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
