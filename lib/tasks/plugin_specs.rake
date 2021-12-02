

#  Run all core and plugins specs via
#  rake spec_all
#
#  Run plugins specs via
#  rake spec_plugins
#
#  A plugin must register for tests via config variable 'plugins_to_test_paths'
#
#  e.g.
#  class Engine < ::Rails::Engine
#    initializer 'register_path_to_rspec' do |app|
#      app.config.plugins_to_test_paths << self.root
#    end
#  end
#

begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc 'Run core and plugin specs'
    RSpec::Core::RakeTask.new(all: [:environment]) do |t|
      t.pattern = [Rails.root.join('spec').to_s] + Plugins::LoadPathHelper.spec_load_paths
    end

    desc 'Run plugin specs'
    RSpec::Core::RakeTask.new(plugins: [:environment]) do |t|
      t.pattern = Plugins::LoadPathHelper.spec_load_paths

      # in case we want to run plugins' specs and there are none
      # we exit with positive message
      if t.pattern.empty?
        puts
        puts '##### There are no specs for ProyeksiApp plugins to be run.'
        puts
        exit(0)
      end
    end
  end
rescue LoadError
end
