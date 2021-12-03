#-- encoding: UTF-8



require 'proyeksi_app/assets'

# The ng build task must run before assets:environment task.
# Otherwise Sprockets cannot find the files that webpack produces.
Rake::Task['assets:precompile']
  .clear_prerequisites
  .enhance(%w[assets:compile_environment assets:prepare_op])

namespace :assets do
  # In this task, set prerequisites for the assets:precompile task
  task compile_environment: :prepare_op do
    # Turn the yarn:install task into a noop.
    Rake::Task['yarn:install']
      .clear

    Rake::Task['assets:environment'].invoke
  end

  desc 'Prepare locales and angular assets'
  task prepare_op: %i[export_locales angular]

  desc 'Compile assets with webpack'
  task :angular do
    # We skip angular compilation if backend was requested
    # but frontend was not explicitly set
    if ENV['RECOMPILE_RAILS_ASSETS'] == 'true' && ENV['RECOMPILE_ANGULAR_ASSETS'] != 'true'
      warn "RECOMPILE_RAILS_ASSETS was set by installation, but RECOMPILE_ANGULAR_ASSETS is false. " \
           "Skipping angular compilation. Set RECOMPILE_ANGULAR_ASSETS='true' if you need to force it."
      next
    end

    ProyeksiApp::Assets.clear!

    puts "Linking frontend plugins"
    Rake::Task['proyeksiapp:plugins:register_frontend'].invoke

    puts "Building angular frontend"
    Dir.chdir Rails.root.join('frontend') do
      sh 'npm run build' do |ok, res|
        raise "Failed to compile angular frontend: #{res.exitstatus}" if !ok
      end
    end

    Rake::Task['assets:rebuild_manifest'].invoke
  end

  desc 'Write angular assets manifest'
  task :rebuild_manifest do
    puts "Writing angular assets manifest"
    ProyeksiApp::Assets.rebuild_manifest!
  end

  desc 'Export frontend locale files'
  task export_locales: ['i18n:js:export']
end
