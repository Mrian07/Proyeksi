#-- encoding: UTF-8

require_relative 'base'

class Tables::EnabledModules < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id
      t.string :name, null: false

      t.index :project_id, name: 'enabled_modules_project_id'
      t.index :name, length: 8
    end
  end
end
