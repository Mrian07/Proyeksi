

module API
  module V3
    module UserPreferences
      class UserPreferencesAPI < ::API::OpenProjectAPI
        resource :my_preferences do
          get do
            redirect api_v3_paths.user_preferences('me'), permanent: true
          end

          patch do
            redirect api_v3_paths.user_preferences('me'), permanent: true
          end
        end
      end
    end
  end
end
