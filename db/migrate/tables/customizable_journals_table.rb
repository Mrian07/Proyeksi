#-- encoding: UTF-8

require_relative 'base'

class Tables::CustomizableJournals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :journal_id, null: false
      t.integer :custom_field_id, null: false
      t.text :value

      t.index :journal_id
      t.index :custom_field_id
    end
  end
end
