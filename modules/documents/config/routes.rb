

OpenProject::Application.routes.draw do
  resources :projects, only: [] do
    resources :documents, only: %i[create new index]
  end

  resources :documents, except: %i[create new index]
end
