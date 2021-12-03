

env = ENV['RAILS_ENV'] || 'production'

if (db_config = ActiveRecord::Base.configurations.configs_for(env_name: env)[0]) &&
   db_config.configuration_hash['adapter']&.start_with?('mysql')
  warn <<~ERROR
    ======= INCOMPATIBLE DATABASE DETECTED =======
    Your database is set up for use with a MySQL or MySQL-compatible variant.
    This installation of ProyeksiApp no longer supports these variants.

    The following guides provide extensive documentation for migrating
    your installation to a PostgreSQL database:

    https://www.proyeksiapp.org/migration-guides/

    This process is mostly automated so you can continue using your
    ProyeksiApp installation within a few minutes!

    ==============================================
  ERROR

  # rubocop:disable Rails:Exit
  Kernel.exit 1
  # rubocop:enable Rails:Exit
end
