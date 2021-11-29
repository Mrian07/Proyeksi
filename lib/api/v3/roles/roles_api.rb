#-- encoding: UTF-8



module API
  module V3
    module Roles
      class RolesAPI < ::API::OpenProjectAPI
        resources :roles do
          after_validation do
            authorize_any(%i[view_members manage_members], global: true)
          end

          get &::API::V3::Utilities::Endpoints::Index.new(model: Role).mount

          route_param :id, type: Integer, desc: 'Role ID' do
            after_validation do
              @role = Role.find(declared_params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: Role).mount
          end
        end
      end
    end
  end
end
