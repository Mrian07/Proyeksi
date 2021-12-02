#-- encoding: UTF-8



require 'api/v3/categories/category_representer'

module API
  module V3
    module Categories
      class CategoriesAPI < ::API::ProyeksiAppAPI
        resources :categories do
          route_param :id, type: Integer, desc: 'Category ID' do
            after_validation do
              @category = Category.find(params[:id])
              authorize(:view_project, context: @category.project) do
                raise API::Errors::NotFound.new
              end
            end

            get do
              CategoryRepresenter.new(@category, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
