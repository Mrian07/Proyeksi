

require_relative 'base'

class Tables::Workflows < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :type_id, default: 0, null: false
      t.integer :old_status_id, default: 0, null: false
      t.integer :new_status_id, default: 0, null: false
      t.integer :role_id, default: 0, null: false
      t.boolean :assignee, default: false, null: false
      t.boolean :author, default: false, null: false

      t.index :new_status_id, name: 'index_workflows_on_new_status_id'
      t.index :old_status_id, name: 'index_workflows_on_old_status_id'
      t.index :role_id, name: 'index_workflows_on_role_id'
      t.index %i[role_id type_id old_status_id], name: 'wkfs_role_type_old_status'
    end
  end
end
