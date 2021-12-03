#-- encoding: UTF-8

require_relative 'base'

class Tables::WikiContentJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :page_id, null: false
      t.integer :author_id
      t.text :text, limit: (1.gigabyte - 1)

      t.index [:journal_id]
    end
  end
end
