#-- encoding: UTF-8

require_relative 'base'

class Tables::WorkPackageJournals < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :type_id, default: 0, null: false
      t.integer :project_id, default: 0, null: false
      t.string :subject, default: '', null: false
      t.text :description
      t.date :due_date
      t.integer :category_id
      t.integer :status_id, default: 0, null: false
      t.integer :assigned_to_id
      t.integer :priority_id, default: 0, null: false
      t.integer :fixed_version_id
      t.integer :author_id, default: 0, null: false
      t.integer :done_ratio, default: 0, null: false
      t.float :estimated_hours
      t.date :start_date
      t.integer :parent_id
      t.integer :responsible_id

      t.index [:journal_id]
    end
    # rubocop:enable Metrics/AbcSize
  end
end
