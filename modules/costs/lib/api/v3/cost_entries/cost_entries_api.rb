#-- encoding: UTF-8



require 'api/v3/cost_types/cost_type_representer'

module API
  module V3
    module CostEntries
      class CostEntriesAPI < ::API::OpenProjectAPI
        resources :cost_entries do
          route_param :id, type: Integer, desc: 'Cost entry ID' do
            after_validation do
              @cost_entry = CostEntry.find(params[:id])

              authorize(:view_cost_entries, context: @cost_entry.project) do
                if current_user == @cost_entry.user
                  authorize(:view_own_cost_entries, context: @cost_entry.project)
                else
                  raise API::Errors::Unauthorized
                end
              end
            end

            get do
              CostEntryRepresenter.new(@cost_entry, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
