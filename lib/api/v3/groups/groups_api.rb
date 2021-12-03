

module API
  module V3
    module Groups
      class GroupsAPI < ::API::ProyeksiAppAPI
        resources :groups do
          after_validation do
            authorize_any %i[view_members manage_members], global: true
          end

          get &::API::V3::Utilities::Endpoints::Index
                 .new(model: Group)
                 .mount
          post &::API::V3::Utilities::Endpoints::Create
                  .new(model: Group)
                  .mount

          route_param :id, type: Integer, desc: 'Group ID' do
            after_validation do
              @group = Group.visible(current_user).find(params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show
                   .new(model: Group)
                   .mount
            patch &::API::V3::Utilities::Endpoints::Update
                     .new(model: Group)
                     .mount
            delete &::API::V3::Utilities::Endpoints::Delete
                     .new(model: Group,
                          success_status: 202)
                     .mount
          end
        end
      end
    end
  end
end
