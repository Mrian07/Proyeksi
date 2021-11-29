

require_relative 'base'

class Tables::Tokens < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :user_id, default: 0, null: false
      t.string :action, limit: 30, default: '', null: false
      t.string :value, limit: 40, default: '', null: false
      t.datetime :created_on, null: false

      t.index :user_id, name: 'index_tokens_on_user_id'
    end
  end
end
