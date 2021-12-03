#-- encoding: UTF-8

require 'api/v3/types/type_collection_representer'
require 'api/v3/types/type_representer'

module API
  module V3
    module Types
      class TypesAPI < ::API::ProyeksiAppAPI
        resources :types do
          after_validation do
            authorize_any(%i[view_work_packages manage_types], global: true)
          end

          get do
            types = Type.includes(:color).all
            TypeCollectionRepresenter
              .new(types,
                   self_link: api_v3_paths.types,
                   current_user: current_user)
          end

          route_param :id, type: Integer, desc: 'Type ID' do
            after_validation do
              type = Type.find(params[:id])
              @representer = TypeRepresenter.new(type, current_user: current_user)
            end

            get do
              @representer
            end
          end
        end
      end
    end
  end
end
