

OpenProject::Application.routes.draw do
  scope '', as: 'bcf' do
    mount ::Bim::Bcf::API::Root => '/api/bcf'

    scope 'projects/:project_id', as: 'project' do
      resources :issues, controller: 'bim/bcf/issues' do
        get :upload, action: :upload, on: :collection
        post :prepare_import, action: :prepare_import, on: :collection
        post :configure_import, action: :configure_import, on: :collection
        post :import, action: :perform_import, on: :collection
      end

      # IFC viewer frontend
      get 'bcf(/*state)', to: 'bim/ifc_models/ifc_viewer#show', as: :frontend

      # IFC model management
      resources :ifc_models, controller: 'bim/ifc_models/ifc_models' do
        collection do
          get :defaults
          get :direct_upload_finished
          post :set_direct_upload_file_name
        end
      end
    end
  end
end
