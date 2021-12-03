#-- encoding: UTF-8

module Migration
  module MigrationUtils
    class ModuleRenamer
      class << self
        def add_to_enabled(new_module, old_modules)
          execute <<~SQL
            INSERT INTO
              enabled_modules (
                project_id,
                name
              )
            SELECT
              DISTINCT(project_id),
              '#{new_module}'
            FROM
              enabled_modules
            WHERE
              name IN (#{comma_separated_strings(old_modules)})
          SQL
        end

        def remove_from_enabled(modules)
          execute <<~SQL
            DELETE FROM
              enabled_modules
            WHERE
              name IN (#{comma_separated_strings(modules)})
          SQL
        end

        def add_to_default(new_modules, old_modules)
          # avoid creating the settings implicitly on new installations
          setting = Setting.find_by(name: 'default_projects_modules')

          return unless setting

          cleaned_setting = setting.value - Array(old_modules)

          if setting.value != cleaned_setting
            Setting.default_projects_modules = cleaned_setting + Array(new_modules)
          end
        end

        def remove_from_default(name)
          add_to_default([], name)
        end

        private

        def execute(string)
          ActiveRecord::Base.connection.execute string
        end

        def comma_separated_strings(array)
          Array(array).map { |i| "'#{i}'" }.join(', ')
        end
      end
    end
  end
end
