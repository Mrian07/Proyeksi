#-- encoding: UTF-8



require 'api/v3/types/type_collection_representer'

module API
  module V3
    module Types
      class TypesByProjectAPI < ::API::OpenProjectAPI
        resources :types do
          after_validation do
            authorize_any %i[view_work_packages manage_types], projects: @project
          end

          get do
            types = @project.types
            TypeCollectionRepresenter.new(types,
                                          self_link: api_v3_paths.types_by_project(@project.id),
                                          current_user: current_user)
          end
        end
      end
    end
  end
end
