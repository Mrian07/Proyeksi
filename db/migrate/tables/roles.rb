

require_relative 'base'

class Tables::Roles < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, limit: 30, default: '', null: false
      t.integer :position, default: 1
      t.boolean :assignable, default: true
      t.integer :builtin, default: 0, null: false
    end
  end
end
