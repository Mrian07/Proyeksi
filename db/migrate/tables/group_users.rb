#-- encoding: UTF-8



require_relative 'base'

class Tables::GroupUsers < Tables::Base
  def self.id_options
    { id: false }
  end

  def self.table(migration)
    create_table migration do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false

      t.index %i(group_id user_id), name: :group_user_ids, unique: true
    end
  end
end
