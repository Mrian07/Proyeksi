require_relative 'base'

class Tables::Queries < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id
      t.string :name, default: '', null: false
      t.text :filters
      t.integer :user_id, default: 0, null: false
      t.boolean :is_public, default: false, null: false
      t.text :column_names
      t.text :sort_criteria
      t.string :group_by
      t.boolean :display_sums, default: false, null: false
      t.boolean :timeline_visible, default: false
      t.boolean :show_hierarchies, default: false
      t.integer :timeline_zoom_level, default: 0

      t.index :project_id, name: 'index_queries_on_project_id'
      t.index :user_id, name: 'index_queries_on_user_id'
    end
  end
end
