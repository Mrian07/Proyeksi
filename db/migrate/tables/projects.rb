require_relative 'base'

class Tables::Projects < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.string :name, default: '', null: false
      t.text :description
      t.boolean :is_public, default: true, null: false
      t.integer :parent_id
      t.datetime :created_on
      t.datetime :updated_on
      t.string :identifier
      t.integer :status, default: 1, null: false
      t.integer :lft
      t.integer :rgt
      t.belongs_to :project_type, type: :int
      t.belongs_to :responsible, type: :int
      t.belongs_to :work_packages_responsible, type: :int

      t.index :lft, name: 'index_projects_on_lft'
      t.index :rgt, name: 'index_projects_on_rgt'
      t.index :identifier
    end
  end

  # rubocop:enable Metrics/AbcSize
end
