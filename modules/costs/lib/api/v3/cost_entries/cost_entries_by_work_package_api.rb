#-- encoding: UTF-8



require 'api/v3/cost_types/cost_type_representer'

module API
  module V3
    module CostEntries
      class CostEntriesByWorkPackageAPI < ::API::OpenProjectAPI
        after_validation do
          authorize_any(%i[view_cost_entries view_own_cost_entries],
                        projects: @work_package.project)
          @cost_helper = ::Costs::AttributesHelper.new(@work_package, current_user)
        end

        resources :cost_entries do
          get do
            path = api_v3_paths.cost_entries_by_work_package(@work_package.id)
            cost_entries = @cost_helper.cost_entries
            CostEntryCollectionRepresenter.new(cost_entries,
                                               cost_entries.count,
                                               self_link: path,
                                               current_user: current_user)
          end
        end

        resources :summarized_costs_by_type do
          get do
            WorkPackageCostsByTypeRepresenter.new(@work_package, current_user: current_user)
          end
        end
      end
    end
  end
end
