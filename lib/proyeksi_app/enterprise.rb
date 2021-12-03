

module ProyeksiApp
  module Enterprise
    class << self
      def token
        EnterpriseToken.current.presence
      end

      def upgrade_url
        "#{Setting.protocol}://#{Setting.host_name}#{upgrade_path}"
      end

      def upgrade_path
        url_helpers.enterprise_path
      end

      def user_limit
        Hash(token.restrictions)[:active_user_count] if token
      end

      def active_user_count
        User.human.active.count
      end

      ##
      # Indicates if there are more active users than the support token allows for.
      #
      # @return [Boolean] True if and only if there is a support token the user limit of which is exceeded.
      def user_limit_reached?
        active_user_count >= user_limit if user_limit
      end

      ##
      # While the active user limit has not been reached yet it would be reached
      # if all registered and invited users were to activate their accounts.
      def imminent_user_limit?
        User.human.not_locked.count > user_limit if user_limit
      end

      def fail_fast?
        Hash(ProyeksiApp::Configuration["enterprise"])["fail_fast"]
      end

      ##
      # Informs active admins about a user who could not be activated due to
      # the user limit having been reached.
      def send_activation_limit_notification_about(user)
        User.active.admin.each do |admin|
          UserMailer.activation_limit_reached(user.mail, admin).deliver_later
        end
      end

      private

      def url_helpers
        @url_helpers ||= ProyeksiApp::StaticRouting::StaticUrlHelpers.new
      end
    end
  end
end
