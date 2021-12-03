require_relative 'base'

class Tables::UserPasswords < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :user_id, null: false
      t.string :hashed_password, limit: 128, null: false
      t.string :salt, limit: 64, null: true
      t.timestamps null: true
      t.string :type, null: false

      t.index :user_id
    end
  end
end
