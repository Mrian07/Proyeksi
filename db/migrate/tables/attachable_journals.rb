#-- encoding: UTF-8

require_relative 'base'

class Tables::AttachableJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :attachment_id, null: false
      t.string :filename, default: '', null: false

      t.index :journal_id
      t.index :attachment_id
    end
  end
end
