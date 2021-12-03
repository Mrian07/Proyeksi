

ProyeksiApp::Application.routes.draw do
  scope 'projects/:project_id', as: 'projects' do
    resources :cost_entries, controller: 'costlog', only: %i[new create]

    resources :hourly_rates, only: %i[show edit update] do
      post :set_rate, on: :member
    end
  end

  scope 'projects/:project_id', as: 'project', module: 'projects' do
    namespace 'settings' do
      resource :time_entry_activities, only: %i[show update]
    end
  end

  scope 'work_packages/:work_package_id', as: 'work_packages' do
    resources :cost_entries, controller: 'costlog', only: %i[new]
  end

  resources :cost_entries, controller: 'costlog', only: %i[edit update destroy]

  resources :cost_types, only: %i[index new edit update create destroy] do
    member do
      # TODO: check if this can be replaced with update method
      put :set_rate
      patch :restore
    end
  end

  # TODO: this is a duplicate from a route defined under project/:project_id, check whether we really want to do that
  resources :hourly_rates, only: %i[edit update]
end
