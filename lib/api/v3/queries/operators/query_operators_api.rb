

module API
  module V3
    module Queries
      module Operators
        class QueryOperatorsAPI < ::API::ProyeksiAppAPI
          resource :operators do
            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            route_param :id, type: String, regexp: /\A\w+\z/, desc: 'Operator ID' do
              get do
                operator = ::Queries::Operators::OPERATORS[params[:id]]

                if operator
                  ::API::V3::Queries::Operators::QueryOperatorRepresenter.new(operator)
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
