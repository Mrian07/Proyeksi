

module OpenProject::Backlogs::Patches::ProjectSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def seed_versions(project, key)
      super

      return unless project_has_data_for?(key, 'versions')

      versions = Array(project_data_for(key, 'versions'))
        .map { |data| Version.find_by(name: data[:name]) }
        .compact

      versions.each do |version|
        display = version_settings_display_map[version.name] || VersionSetting::DISPLAY_NONE
        version.version_settings.create! display: display, project: version.project
      end
    end

    ##
    # This relies on the names from the core's `config/locales/en.seeders.yml`.
    def version_settings_display_map
      {
        'Sprint 1' => VersionSetting::DISPLAY_LEFT,
        'Sprint 2' => VersionSetting::DISPLAY_LEFT,
        'Bug Backlog' => VersionSetting::DISPLAY_RIGHT,
        'Product Backlog' => VersionSetting::DISPLAY_RIGHT,
        'Wish List' => VersionSetting::DISPLAY_RIGHT
      }
    end
  end
end
