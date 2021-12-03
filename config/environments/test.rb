#-- encoding: UTF-8



ProyeksiApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Access to rack session
  config.middleware.use RackSessionAccess::Middleware

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = ENV['CI'].present?

  # Use eager load to mirror the production environment
  # on travis
  config.eager_load = ENV['CI'].present?

  # This setting is false by default, but we define it explicitly
  config.allow_concurrency = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=3600' }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation =
    if ENV['CI']
      :silence
    else
      :stderr
    end

  # Disable asset digests
  config.assets.compile = true
  config.assets.compress = false
  config.assets.digest = false
  config.assets.debug = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.cache_store = :file_store, Rails.root.join("tmp", "cache", "paralleltests#{ENV['TEST_ENV_NUMBER']}")

  if ENV['TEST_ENV_NUMBER']
    assets_cache_path = Rails.root.join("tmp/cache/assets/paralleltests#{ENV['TEST_ENV_NUMBER']}")
    config.assets.cache = Sprockets::Cache::FileStore.new(assets_cache_path)
  end
end
