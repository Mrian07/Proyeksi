#-- encoding: UTF-8

require_relative 'base'

class Tables::WorkPackages < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.integer :type_id, default: 0, null: false
      t.belongs_to :project, default: 0, null: false, type: :int
      t.string :subject, default: '', null: false
      t.text :description
      t.date :due_date
      t.integer :category_id
      t.integer :status_id, default: 0, null: false
      t.integer :assigned_to_id
      t.integer :priority_id, null: true, default: 0
      t.integer :fixed_version_id
      t.integer :author_id, default: 0, null: false
      t.integer :lock_version, default: 0, null: false
      t.integer :done_ratio, default: 0, null: false
      t.float :estimated_hours
      t.timestamps null: true
      t.date :start_date
      t.belongs_to :parent, default: nil, type: :int
      t.belongs_to :responsible, type: :int

      # Nested Set
      t.integer :root_id, default: nil
      t.integer :lft, default: nil
      t.integer :rgt, default: nil

      # Nested Set
      t.index %i[root_id lft rgt]

      t.index :type_id
      t.index :status_id
      t.index :category_id
      t.index :author_id
      t.index :assigned_to_id
      t.index :created_at
      t.index :fixed_version_id
      t.index :updated_at
      t.index %i[project_id updated_at]
    end
  end

  # rubocop:enable Metrics/AbcSize
end
