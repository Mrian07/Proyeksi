#-- encoding: UTF-8



module API
  module V3
    module Budgets
      class BudgetsAPI < ::API::ProyeksiAppAPI
        resources :budgets do
          route_param :id, type: Integer, desc: 'Budget ID' do
            after_validation do
              @budget = Budget.find(params[:id])

              authorize(:view_budgets, context: @budget.project)
            end

            get do
              BudgetRepresenter.new(@budget, current_user: current_user)
            end

            mount ::API::V3::Attachments::AttachmentsByBudgetAPI
          end
        end
      end
    end
  end
end
