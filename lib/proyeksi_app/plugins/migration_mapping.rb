
module ProyeksiApp::Plugins
  module MigrationMapping
    def self.migration_files_to_migration_names(migration_files, old_plugin_name)
      migration_files.split.map do |m|
        # take only the version number without leading zeroes and concatenate it with the old plugin name
        m.to_i.to_s + '-' + old_plugin_name
      end
    end
  end
end
