require 'api/v3/users/user_representer'
require 'api/v3/users/paginated_user_collection_representer'

module API
  module V3
    module Users
      class UsersAPI < ::API::ProyeksiAppAPI
        helpers ::API::Utilities::PageSizeHelper

        helpers do
          def user_transition(allowed)
            if allowed
              yield

              # Show updated user
              status 200
              UserRepresenter.new(@user, current_user: current_user)
            else
              fail ::API::Errors::InvalidUserStatusTransition
            end
          end

          def authorize_user_cru_allowed
            authorize_by_with_raise(current_user.allowed_to_globally?(:manage_user))
          end
        end

        resources :users do
          post &::API::V3::Utilities::Endpoints::Create.new(model: User).mount

          get do
            authorize_user_cru_allowed

            query = ParamsToQueryService.new(User, current_user).call(params)

            if query.valid?
              users = query.results.includes(:preference)
              PaginatedUserCollectionRepresenter.new(users,
                                                     self_link: api_v3_paths.users,
                                                     page: to_i_or_nil(params[:offset]),
                                                     per_page: resolve_page_size(params[:pageSize]),
                                                     current_user: current_user)
            else
              raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
            end
          end

          mount ::API::V3::Users::Schemas::UserSchemaAPI
          mount ::API::V3::Users::CreateFormAPI

          params do
            requires :id, desc: 'User\'s id'
          end
          route_param :id do
            after_validation do
              @user =
                if params[:id] == 'me'
                  User.current
                else
                  User.find_by_unique!(params[:id])
                end
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: User).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: User).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: User, success_status: 202).mount

            mount ::API::V3::Users::UpdateFormAPI
            mount ::API::V3::UserPreferences::PreferencesByUserAPI

            namespace :lock do
              # Authenticate lock transitions
              after_validation do
                authorize_admin
              end

              desc 'Set lock on user account'
              post do
                user_transition(@user.active? || @user.locked?) do
                  @user.lock! unless @user.locked?
                end
              end

              desc 'Remove lock on user account'
              delete do
                user_transition(@user.locked? || @user.active?) do
                  @user.activate! unless @user.active?
                end
              end
            end
          end
        end
      end
    end
  end
end
