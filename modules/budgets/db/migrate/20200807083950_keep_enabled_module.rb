#-- encoding: UTF-8



require Rails.root.to_s + '/db/migrate/migration_utils/module_renamer'

class KeepEnabledModule < ActiveRecord::Migration[6.0]
  def up
    module_renamer.add_to_enabled('budgets', %w[costs_module])
    module_renamer.add_to_default('budgets', %w[costs_module])
  end

  def down
    module_renamer.remove_from_enabled('budgets')
    module_renamer.remove_from_default('budgets')
  end

  private

  def module_renamer
    Migration::MigrationUtils::ModuleRenamer
  end
end
