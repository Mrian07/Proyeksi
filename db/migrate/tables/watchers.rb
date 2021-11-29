

require_relative 'base'

class Tables::Watchers < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :watchable_type, default: '', null: false
      t.integer :watchable_id, default: 0, null: false
      t.integer :user_id

      t.index %i(user_id watchable_type), name: 'watchers_user_id_type'
      t.index :user_id, name: 'index_watchers_on_user_id'
      t.index %i(watchable_id watchable_type), name: 'index_watchers_on_watchable_id_and_watchable_type'
    end
  end
end
