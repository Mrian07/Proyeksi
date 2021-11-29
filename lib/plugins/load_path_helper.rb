

module Plugins
  module LoadPathHelper
    def self.spec_load_paths
      plugin_load_paths.map do |path|
        File.join(path, 'spec')
      end.keep_if { |path| File.directory?(path) }
    end

    # fetch load paths for available plugins
    def self.plugin_load_paths
      Rails.application.config.plugins_to_test_paths.map(&:to_s)
    end
  end
end
