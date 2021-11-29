

require_relative 'base'

class Tables::Statuses < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, limit: 30, default: '', null: false
      t.boolean :is_closed, default: false, null: false
      t.boolean :is_default, default: false, null: false
      t.integer :position, default: 1
      t.integer :default_done_ratio

      t.index :is_closed, name: 'index_statuses_on_is_closed'
      t.index :is_default, name: 'index_statuses_on_is_default'
      t.index :position, name: 'index_statuses_on_position'
    end
  end
end
