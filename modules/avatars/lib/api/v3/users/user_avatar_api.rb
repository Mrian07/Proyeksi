#-- encoding: UTF-8



module API
  module V3
    module Users
      class UserAvatarAPI < ::API::OpenProjectAPI
        helpers ::AvatarHelper
        helpers ::API::Helpers::AttachmentRenderer

        finally do
          set_cache_headers
        end

        get '/avatar' do
          cache_seconds = @user == current_user ? nil : avatar_link_expires_in

          if (local_avatar = local_avatar?(@user))
            respond_with_attachment(local_avatar, cache_seconds: cache_seconds)
          elsif avatar_manager.gravatar_enabled?
            set_cache_headers!(cache_seconds) if cache_seconds

            redirect build_gravatar_image_url(@user)
          else
            status 404
          end
        rescue StandardError => e
          # Exceptions may happen due to invalid mails in the avatar builder
          # but we ensure that a 404 is returned in that case for consistency
          Rails.logger.error { "Failed to render #{@user&.id} avatar: #{e.message}" }
          status 404
        end
      end
    end
  end
end
