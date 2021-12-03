module API
  module V3
    module PlaceholderUsers
      class PlaceholderUsersAPI < ::API::ProyeksiAppAPI
        resources :placeholder_users do
          get &::API::V3::Utilities::Endpoints::Index
                 .new(model: PlaceholderUser, scope: -> { PlaceholderUser.visible(current_user) })
                 .mount

          post &::API::V3::Utilities::Endpoints::Create
                  .new(model: PlaceholderUser)
                  .mount

          route_param :id, type: Integer, desc: 'Placeholder user ID' do
            after_validation do
              authorize_any %i[manage_placeholder_user manage_members], global: true
              @placeholder_user = PlaceholderUser.visible.find(params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: PlaceholderUser).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: PlaceholderUser).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: PlaceholderUser, success_status: 202).mount
          end
        end
      end
    end
  end
end
