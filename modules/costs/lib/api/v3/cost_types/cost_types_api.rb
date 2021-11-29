#-- encoding: UTF-8



require 'api/v3/cost_types/cost_type_representer'

module API
  module V3
    module CostTypes
      class CostTypesAPI < ::API::OpenProjectAPI
        resources :cost_types do
          after_validation do
            authorize_any(%i[view_cost_entries view_own_cost_entries],
                          global: true,
                          user: current_user)
          end

          route_param :id, type: Integer, desc: 'Cost type ID' do
            after_validation do
              @cost_type = CostType.active.find(params[:id])
            end

            get do
              CostTypeRepresenter.new(@cost_type, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
