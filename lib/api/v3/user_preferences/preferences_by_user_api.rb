

module API
  module V3
    module UserPreferences
      class PreferencesByUserAPI < ::API::ProyeksiAppAPI
        resource :preferences do
          # The empty namespaces are added so that anonymous users can receive a 401 response
          namespace '' do
            after_validation do
              authorize_by_with_raise(current_user.allowed_to_globally?(:manage_user) || @user == current_user)
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: UserPreference,
                                                           instance_generator: ->(*) { @user.pref })
                                                      .mount
          end

          namespace '' do
            after_validation do
              authorize_by_with_raise(current_user.allowed_to_globally?(:manage_user) ||
                                        current_user.logged? && @user == current_user) do
                if current_user.anonymous?
                  raise API::Errors::Unauthenticated
                else
                  raise API::Errors::Unauthorized
                end
              end
            end

            patch &::API::V3::Utilities::Endpoints::Update.new(model: UserPreference,
                                                               instance_generator: ->(*) { @user.pref })
                                                          .mount
          end
        end
      end
    end
  end
end
