#-- encoding: UTF-8

##
# An extension to the SqlBypass class to store
# sessions in database without going through ActiveRecord
module Sessions
  class SqlBypass < ::ActiveRecord::SessionStore::SqlBypass
    class << self
      ##
      # Looks up session data for a given session ID.
      #
      # This is not specific to AR sessions which are stored as AR records.
      # But this is the probably the first place one would search for session-related
      # methods. I.e. this works just as well for cache- and file-based sessions.
      #
      # @param session_id [String] The session ID as found in the `_open_project_session` cookie
      # @return [Hash] The saved session data (user_id, updated_at, etc.) or nil if no session was found.
      def lookup_data(session_id)
        rack_session = Rack::Session::SessionId.new(session_id)
        if Rails.application.config.session_store == ActionDispatch::Session::ActiveRecordStore
          find_by_session_id(rack_session.private_id)&.data
        else
          session_store = Rails.application.config.session_store.new nil, {}
          _id, data = session_store.instance_eval do
            find_session({}, rack_session)
          end

          data.presence
        end
      end

      def connection_pool
        ::ActiveRecord::Base.connection_pool
      end

      def connection
        ::ActiveRecord::Base.connection
      end
    end

    # Ensure we use our own class methods for delegation of the connection
    # otherwise the memoized superclass is being used
    delegate :connection, :connection_pool, to: :class

    ##
    # Save while updating the user_id reference and updated_at column
    def save
      return false unless loaded?

      if @new_record
        insert!
      else
        update!
      end
    end

    ##
    # Also destroy any other session when this one is actively destroyed
    def destroy
      delete_user_sessions
      super
    end

    private

    def user_id
      id = data.with_indifferent_access['user_id'].to_i
      id > 0 ? id : nil
    end

    def insert!
      @new_record = false
      connection.update <<~SQL, 'Create session'
         INSERT INTO sessions (session_id, data, user_id, updated_at)
         VALUES (
           #{connection.quote(session_id)},
           #{connection.quote(self.class.serialize(data))},
           #{connection.quote(user_id)},
           (now() at time zone 'utc')
        )
      SQL
    end

    def update!
      connection.update <<~SQL, 'Update session'
        UPDATE sessions
        SET
          data=#{connection.quote(self.class.serialize(data))},
          session_id=#{connection.quote(session_id)},
          user_id=#{connection.quote(user_id)},
          updated_at=(now() at time zone 'utc')
        WHERE session_id=#{connection.quote(@retrieved_by)}
      SQL
    end

    def delete_user_sessions
      uid = user_id
      return unless uid && ProyeksiApp::Configuration.drop_old_sessions_on_logout?

      ::Sessions::UserSession.for_user(uid).delete_all
    end
  end
end
