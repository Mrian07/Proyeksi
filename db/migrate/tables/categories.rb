require_relative 'base'

class Tables::Categories < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, default: 0, null: false
      t.string :name, limit: 256, null: false, default: ''
      t.integer :assigned_to_id

      t.index :assigned_to_id, name: 'index_categories_on_assigned_to_id'
      t.index :project_id, name: 'issue_categories_project_id'
    end
  end
end
