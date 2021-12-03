require_relative 'base'

class Tables::Members < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :user_id, default: 0, null: false
      t.integer :project_id, default: 0, null: false
      t.datetime :created_on
      t.boolean :mail_notification, default: false, null: false

      t.index :project_id, name: 'index_members_on_project_id'
      t.index %i[user_id project_id], name: 'index_members_on_user_id_and_project_id', unique: true
      t.index :user_id, name: 'index_members_on_user_id'
    end
  end
end
