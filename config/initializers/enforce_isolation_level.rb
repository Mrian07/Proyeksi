#-- encoding: UTF-8



# We need to ensure that we operate on a well-known TRANSACTION ISOLATION LEVEL
# However, the default isolation level is different for MySQL and PostgreSQL and it is also
# possible (at least for MySQL) to globally override the default for your DBMS installation.
# Therefore we want to ensure that the isolation level is consistent on a session basis.
# We chose READ COMMITTED as our expected default isolation level, this is the default of
# PostgreSQL.
module ConnectionIsolationLevel
  module ConnectionPoolPatch
    def new_connection
      connection = super
      ConnectionIsolationLevel.set_connection_isolation_level connection
      connection
    end
  end

  def self.set_connection_isolation_level(connection)
    isolation_level = 'ISOLATION LEVEL READ COMMITTED'
    if ProyeksiApp::Database.postgresql?(connection)
      connection.execute("SET SESSION CHARACTERISTICS AS TRANSACTION #{isolation_level}")
    end
  end
end

ActiveRecord::ConnectionAdapters::ConnectionPool.prepend ConnectionIsolationLevel::ConnectionPoolPatch

# in case the existing connection was created before our patch
# N.B.: this assumes that our process only has this single thread, which is at least true today...
ConnectionIsolationLevel.set_connection_isolation_level ActiveRecord::Base.connection
