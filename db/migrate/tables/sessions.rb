#-- encoding: UTF-8

require_relative 'base'

class Tables::Sessions < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :session_id, null: false
      t.text :data
      t.timestamps null: true
      t.belongs_to :user, type: :int, index: false

      t.index :session_id
      t.index :updated_at
    end
  end
end
