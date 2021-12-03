#-- encoding: UTF-8

require_relative 'base'

class Tables::MessageJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :board_id, null: false
      t.integer :parent_id
      t.string :subject, default: '', null: false
      t.text :content
      t.integer :author_id
      t.integer :replies_count, default: 0, null: false
      t.integer :last_reply_id
      t.boolean :locked, default: false
      t.integer :sticky, default: 0

      t.index [:journal_id]
    end
  end
end
