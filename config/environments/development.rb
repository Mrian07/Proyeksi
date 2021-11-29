#-- encoding: UTF-8



OpenProject::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Automatically refresh translations with I18n middleware
  config.middleware.use ::I18n::JS::Middleware

  # Do not eager load code on boot.
  config.eager_load = false

  # Asynchronous file watcher
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable caching in development
  config.action_controller.perform_caching = true

  # Don't perform caching for Action Mailer in development
  config.action_mailer.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Disable compression and asset digests, but disable debug
  config.assets.debug = false
  config.assets.digest = false

  # Suppress asset output
  config.assets.quiet = true unless config.log_level == :debug

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Send mails to browser window
  config.action_mailer.delivery_method = :letter_opener

  config.hosts << 'bs-local.com' if ENV['OPENPROJECT_DISABLE_DEV_ASSET_PROXY'].present?
end

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT) unless String(ENV["SILENCE_SQL_LOGS"]).to_bool
