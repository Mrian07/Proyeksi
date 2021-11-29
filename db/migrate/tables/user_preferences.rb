

require_relative 'base'

class Tables::UserPreferences < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :user_id, default: 0, null: false
      t.text :others
      t.boolean :hide_mail, default: true
      t.string :time_zone
      t.boolean :impaired, default: false

      t.index :user_id, name: 'index_user_preferences_on_user_id'
    end
  end
end
