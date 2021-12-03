#-- encoding: UTF-8

require_relative 'base'

class Tables::Announcements < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.text :text
      t.date :show_until
      t.boolean :active, default: false
      t.timestamps null: true # compatibility to pre 5.1 migrations

      t.index %i[show_until active]
    end
  end
end
