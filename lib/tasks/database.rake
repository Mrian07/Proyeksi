

namespace 'db:sessions' do
  desc 'Expire old sessions from the sessions table'
  task :expire, [:days_ago] => [:environment, 'db:load_config'] do |_task, args|
    # sessions expire after 30 days of inactivity by default
    days_ago = Integer(args[:days_ago] || 30)
    expiration_time = Date.today - days_ago.days

    sessions_table = ActiveRecord::SessionStore::Session.table_name
    ActiveRecord::Base.connection.execute "DELETE FROM #{sessions_table} WHERE updated_at < '#{expiration_time}'"
  end
end

namespace 'openproject' do
  namespace 'db' do
    desc 'Ensure database version compatibility'
    task check_connection: %w[environment db:load_config] do
      begin
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection.execute "SELECT 1;"
        unless ActiveRecord::Base.connected?
          puts "Database connection failed"
          Kernel.exit 1
        end
      rescue StandardError => e
        puts "Database connection failed with error: #{e}"
        Kernel.exit 1
      end
    end

    desc 'Ensure database version compatibility'
    task ensure_database_compatibility: %w[openproject:db:check_connection] do
      ##
      # Ensure database server version is compatible
      OpenProject::Database::check!
    rescue OpenProject::Database::UnsupportedDatabaseError => e
      warn <<~MESSAGE

        ---------------------------------------------------
        DATABASE UNSUPPORTED ERROR

        #{e.message}

        For more information, see the system requirements.
        https://www.openproject.org/system-requirements/
        ---------------------------------------------------
      MESSAGE
      Kernel.exit(1)
    rescue OpenProject::Database::InsufficientVersionError => e
      warn <<~MESSAGE

        ---------------------------------------------------
        DATABASE INCOMPATIBILITY ERROR

        #{e.message}

        For more information, visit our upgrading documentation:
        https://www.openproject.org/operations/upgrading/
        ---------------------------------------------------
      MESSAGE
      Kernel.exit(1)
    rescue OpenProject::Database::DeprecatedVersionWarning => e
      warn <<~MESSAGE

        ---------------------------------------------------
        DATABASE DEPRECATION WARNING

        #{e.message}
        ---------------------------------------------------
      MESSAGE
    rescue ActiveRecord::ActiveRecordError => e
      warn "Failed to perform postgres version check: #{e} - #{e.message}. #{override_msg}"
      raise e
    end
  end
end

Rake::Task["db:migrate"].enhance ["openproject:db:ensure_database_compatibility"]
