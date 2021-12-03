#-- encoding: UTF-8



require 'api/v3/categories/category_collection_representer'

module API
  module V3
    module Categories
      class CategoriesByProjectAPI < ::API::ProyeksiAppAPI
        resources :categories do
          after_validation do
            @categories = @project.categories
          end

          get do
            self_link = api_v3_paths.categories_by_project(@project.identifier)

            CategoryCollectionRepresenter
              .new(@categories, self_link: self_link, current_user: current_user)
          end
        end
      end
    end
  end
end
