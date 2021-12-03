#-- encoding: UTF-8

require_relative 'base'

class Tables::NewsJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :project_id
      t.string :title, limit: 60, default: '', null: false
      t.string :summary, default: ''
      t.text :description
      t.integer :author_id, default: 0, null: false
      t.integer :comments_count, default: 0, null: false

      t.index [:journal_id]
    end
  end
end
