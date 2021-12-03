#-- encoding: UTF-8

module BasicData
  class SettingSeeder < Seeder
    def seed_data!
      Setting.transaction do
        settings_not_in_db.each do |setting_name|
          datum = data[setting_name]

          Setting[setting_name.to_sym] = datum
        end
      end
    end

    def applicable?
      !settings_not_in_db.empty?
    end

    def not_applicable_message
      'Skipping settings as all settings already exist in the db'
    end

    def data
      @settings ||= begin
                      settings = Setting.available_settings.each_with_object({}) do |(k, v), hash|
                        hash[k] = v['default'] || ''
                      end

                      # deviate from the defaults specified in settings.yml here
                      # to set a default role. The role cannot be specified in the settings.yml as
                      # that would mean to know the ID upfront.
                      update_unless_present(settings, 'new_project_user_role_id') do
                        Role.find_by(name: I18n.t(:default_role_project_admin)).try(:id)
                      end

                      # Set the closed status for repository commit references
                      update_unless_present(settings, 'commit_fix_status_id') do
                        Status.find_by(name: I18n.t(:default_status_closed)).try(:id)
                      end

                      settings
                    end
    end

    private

    def update_unless_present(settings, key)
      if !settings_in_db.include?(key)
        value = yield
        settings[key] = value unless value.nil?
      end
    end

    def settings_in_db
      @settings_in_db ||= Setting.all.pluck(:name)
    end

    def settings_not_in_db
      data.keys - settings_in_db
    end
  end
end
