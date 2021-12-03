

ProyeksiApp::Application.routes.draw do
  scope 'projects/:project_id' do
    resources :cost_reports, except: :create do
      collection do
        match :index, via: %i[get post]
      end

      member do
        post :update
        post :rename
      end
    end
  end

  resources :cost_reports, except: :create do
    collection do
      match :index, via: %i[get post]
      post :save_as, action: :create
      get :drill_down
      match :available_values, via: %i[get post]
      get :display_report_list
    end

    member do
      post :update
      post :rename
    end
  end
end
