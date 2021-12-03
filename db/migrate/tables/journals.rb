#-- encoding: UTF-8

require_relative 'base'

class Tables::Journals < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.references :journable, polymorphic: true, index: false, type: :int
      t.integer :user_id, default: 0, null: false
      t.text :notes
      t.datetime :created_at, null: false
      t.integer :version, default: 0, null: false
      t.string :activity_type

      t.index :journable_id
      t.index :created_at
      t.index :journable_type
      t.index :user_id
      t.index :activity_type
      t.index %i[journable_type journable_id version],
              unique: true
    end
  end
end
