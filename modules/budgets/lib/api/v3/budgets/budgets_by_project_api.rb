#-- encoding: UTF-8



module API
  module V3
    module Budgets
      class BudgetsByProjectAPI < ::API::ProyeksiAppAPI
        resources :budgets do
          after_validation do
            authorize(:view_budgets, context: @project)
            @budgets = @project.budgets
          end

          get do
            BudgetCollectionRepresenter.new(@budgets,
                                            @budgets.count,
                                            self_link: api_v3_paths.budgets_by_project(@project.id),
                                            current_user: current_user)
          end
        end
      end
    end
  end
end
