#-- encoding: UTF-8

require_relative './base_service'

module Sessions
  class InitializeSessionService < BaseService
    class << self
      ##
      # Initializes a new session for the given user.
      # This services provides very little for what it is called,
      # mainly caused due to the many ways a user can login.
      def call(user, session)
        session[:user_id] = user.id
        session[:updated_at] = Time.now

        if drop_old_sessions?
          Rails.logger.info { "Deleting all other sessions for #{user}." }
          ::Sessions::UserSession.for_user(user).delete_all
        end

        ServiceResult.new(success: true, result: session)
      end

      private

      ##
      # We can only drop old sessions if they're stored in the database
      # and enabled by configuration.
      def drop_old_sessions?
        active_record_sessions? && ProyeksiApp::Configuration.drop_old_sessions_on_login?
      end
    end
  end
end
