

require_relative 'base'

class Tables::RolePermissions < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :permission
      t.integer :role_id

      t.index :role_id

      t.timestamps
    end
  end
end
