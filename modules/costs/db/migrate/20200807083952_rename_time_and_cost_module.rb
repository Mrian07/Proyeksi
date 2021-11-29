#-- encoding: UTF-8



require Rails.root.to_s + '/db/migrate/migration_utils/module_renamer'
require Rails.root.to_s + '/db/migrate/migration_utils/setting_renamer'

class RenameTimeAndCostModule < ActiveRecord::Migration[6.0]
  def up
    module_renamer.add_to_enabled('costs', %w[time_tracking costs_module reporting_module])
    module_renamer.remove_from_enabled(%w[time_tracking costs_module reporting_module])
    module_renamer.add_to_default('costs', %w[time_tracking costs_module reporting_module])
    setting_renamer.rename('plugin_costs', 'plugin_costs')
  end

  def down
    # We do not know if all three where actually enabled but having them enabled will keep the functionality
    module_renamer.add_to_enabled('time_tracking', 'costs')
    module_renamer.add_to_enabled('costs_module', 'costs')
    module_renamer.add_to_enabled('reporting_module', 'costs')

    module_renamer.remove_from_enabled('costs')
    module_renamer.add_to_default(%w[costs_module time_tracking reporting_module], 'costs')
    setting_renamer.rename('plugin_costs', 'plugin_costs')
  end

  def module_renamer
    Migration::MigrationUtils::ModuleRenamer
  end

  def setting_renamer
    Migration::MigrationUtils::SettingRenamer
  end
end
