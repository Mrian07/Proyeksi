#-- encoding: UTF-8

require_relative 'base'

class Tables::ChangesetJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :repository_id, null: false
      t.string :revision, null: false
      t.string :committer
      t.datetime :committed_on, null: false
      t.text :comments
      t.date :commit_date
      t.string :scmid
      t.integer :user_id

      t.index [:journal_id]
    end
  end
end
