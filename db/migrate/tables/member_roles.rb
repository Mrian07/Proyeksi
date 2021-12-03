require_relative 'base'

class Tables::MemberRoles < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :member_id, null: false
      t.integer :role_id, null: false
      t.integer :inherited_from

      t.index :member_id, name: 'index_member_roles_on_member_id'
      t.index :role_id, name: 'index_member_roles_on_role_id'
      t.index :inherited_from
    end
  end
end
