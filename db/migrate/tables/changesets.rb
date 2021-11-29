#-- encoding: UTF-8



require_relative 'base'

class Tables::Changesets < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :repository_id, null: false
      t.string :revision, null: false
      t.string :committer
      t.datetime :committed_on, null: false
      t.text :comments
      t.date :commit_date
      t.string :scmid
      t.integer :user_id

      t.index :committed_on, name: 'index_changesets_on_committed_on'
      t.index %i[repository_id revision], name: 'changesets_repos_rev', unique: true
      t.index %i[repository_id scmid], name: 'changesets_repos_scmid'
      t.index :repository_id, name: 'index_changesets_on_repository_id'
      t.index :user_id, name: 'index_changesets_on_user_id'
      t.index %i[repository_id committed_on]
    end
  end
end
