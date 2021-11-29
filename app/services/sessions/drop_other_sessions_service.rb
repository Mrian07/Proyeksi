#-- encoding: UTF-8


require_relative './base_service'

module Sessions
  class DropOtherSessionsService < BaseService
    class << self
      ##
      # Drop all other sessions for the current user.
      # This can only be done when active record sessions are used.
      def call(user, session)
        return false unless active_record_sessions?

        ::Sessions::UserSession
          .for_user(user)
          .where.not(session_id: session.id.private_id)
          .delete_all

        true
      end
    end
  end
end
