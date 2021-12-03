require_relative 'base'

class Tables::Wikis < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, null: false
      t.string :start_page, null: false
      t.integer :status, default: 1, null: false

      t.index :project_id, name: 'wikis_project_id'
    end
  end
end
