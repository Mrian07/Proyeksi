#-- encoding: UTF-8



OpenProject::Application.routes.draw do
  scope 'projects/:project_id', as: 'projects' do
    resources :budgets, only: %i[new create index] do
      match :update_labor_budget_item, on: :collection, via: %i[get post]
      match :update_material_budget_item, on: :collection, via: %i[get post]
    end
  end

  resources :budgets, only: %i[show update destroy edit] do
    get :copy, on: :member
    get :destroy_info, on: :member
  end
end
