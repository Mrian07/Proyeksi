

ProyeksiApp::Application.routes.draw do
  scope 'projects/:project_id' do
    resources :meetings, only: %i[new create index]
  end

  resources :meetings, except: %i[new create index] do
    resource :agenda, controller: 'meeting_agendas', only: [:update] do
      member do
        get :history
        get :diff
        put :close
        put :open
        put :notify
        put :icalendar
        post :preview
      end

      resources :versions, only: [:show],
                           controller: 'meeting_agendas'
    end

    resource :contents, controller: 'meeting_contents', only: %i[show update] do
      member do
        get :history
        get :diff
        put :notify
        get :icalendar
      end
    end

    resource :minutes, controller: 'meeting_minutes', only: [:update] do
      member do
        get :history
        get :diff
        put :notify
        post :preview
      end

      resources :versions, only: [:show],
                           controller: 'meeting_minutes'
    end

    member do
      get :copy
      match '/:tab' => 'meetings#show', :constraints => { tab: /(agenda|minutes)/ },
            :via => :get,
            :as => 'tab'
    end
  end
end
