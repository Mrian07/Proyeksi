

require_relative 'base'

class Tables::Versions < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, default: 0, null: false
      t.string :name, default: '', null: false
      t.string :description, default: ''
      t.date :effective_date
      t.datetime :created_on
      t.datetime :updated_on
      t.string :wiki_page_title
      t.string :status, default: :open
      t.string :sharing, default: :none, null: false
      t.date :start_date

      t.index :project_id, name: 'versions_project_id'
      t.index :sharing, name: 'index_versions_on_sharing'
    end
  end
end
