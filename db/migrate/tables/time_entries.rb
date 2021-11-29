#-- encoding: UTF-8



require_relative 'base'

class Tables::TimeEntries < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.belongs_to :work_package, type: :int, index: false
      t.float :hours, null: false
      t.string :comments
      t.integer :activity_id, null: false
      t.date :spent_on, null: false
      t.integer :tyear, null: false
      t.integer :tmonth, null: false
      t.integer :tweek, null: false
      t.datetime :created_on, null: false
      t.datetime :updated_on, null: false

      t.index :activity_id, name: 'index_time_entries_on_activity_id'
      t.index :created_on, name: 'index_time_entries_on_created_on'
      t.index :work_package_id, name: 'time_entries_issue_id' # issue_id for backwards compatibility
      t.index :project_id, name: 'time_entries_project_id'
      t.index :user_id, name: 'index_time_entries_on_user_id'
      t.index %i[project_id updated_on]
    end
  end
  # rubocop:enable Metrics/AbcSize
end
