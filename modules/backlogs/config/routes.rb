

OpenProject::Application.routes.draw do
  scope '', as: 'backlogs' do
    scope 'projects/:project_id', as: 'project' do
      resources :backlogs,         controller: :rb_master_backlogs,  only: :index

      resources :sprints,          controller: :rb_sprints,          only: %i[show update] do
        resource :query,            controller: :rb_queries,          only: :show

        resource :taskboard,        controller: :rb_taskboards,       only: :show

        resource :wiki,             controller: :rb_wikis,            only: %i[show edit]

        resource :burndown_chart,   controller: :rb_burndown_charts,  only: :show

        resources :impediments,      controller: :rb_impediments,      only: %i[create update]

        resources :tasks,            controller: :rb_tasks,            only: %i[create update]

        resources :export_card_configurations, controller: :rb_export_card_configurations, only: %i[index show] do
          resources :stories, controller: :rb_stories, only: [:index]
        end

        resources :stories, controller: :rb_stories, only: %i[create update]
      end

      resource :query, controller: :rb_queries, only: :show
    end
  end

  scope 'projects/:project_id', as: 'project', module: 'projects' do
    namespace 'settings' do
      resource :backlogs, only: %i[show update] do
        member do
          post 'rebuild_positions' => 'backlogs#rebuild_positions'
        end
      end
    end
  end

  get 'projects/:project_id/versions/:id/edit' => 'version_settings#edit'

  scope 'admin' do
    resource :backlogs,
             only: %i[show update],
             controller: :backlogs_settings,
             as: 'admin_backlogs_settings'
  end
end
