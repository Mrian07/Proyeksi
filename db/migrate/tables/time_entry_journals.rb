#-- encoding: UTF-8



require_relative 'base'

class Tables::TimeEntryJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.integer :work_package_id
      t.float :hours, null: false
      t.string :comments
      t.integer :activity_id, null: false
      t.date :spent_on, null: false
      t.integer :tyear, null: false
      t.integer :tmonth, null: false
      t.integer :tweek, null: false

      t.index [:journal_id]
    end
  end
end
