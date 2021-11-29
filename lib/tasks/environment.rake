#-- encoding: UTF-8



namespace 'environment' do
  desc 'Force application to eager load if configured (does not happen by default for rake tasks)'
  task :full do
    warn "Forcefully loading the application. Use :environment to avoid eager loading."

    ##
    # Require the environment, bypassing the default :environment flag
    Rails.application.require_environment!
  end

  desc 'Eager load the application (only applicable in dev mode)'
  task eager_load: :environment do
    ::Zeitwerk::Loader.eager_load_all if Rails.env.development?
  end
end
