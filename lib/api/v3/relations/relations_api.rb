

require 'api/v3/relations/relation_representer'
require 'api/v3/relations/relation_collection_representer'

require 'relations/create_service'
require 'relations/update_service'

module API
  module V3
    module Relations
      class RelationsAPI < ::API::OpenProjectAPI
        resources :relations do
          get do
            scope = Relation
                    .non_hierarchy
                    .includes(::API::V3::Relations::RelationRepresenter.to_eager_load)

            ::API::V3::Utilities::ParamsToQuery.collection_response(scope,
                                                                    current_user,
                                                                    params)
          end

          route_param :id, type: Integer, desc: 'Relation ID' do
            after_validation do
              @relation = Relation.visible.find(params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: Relation).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: Relation).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: Relation).mount
          end
        end
      end
    end
  end
end
