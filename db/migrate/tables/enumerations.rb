#-- encoding: UTF-8

require_relative 'base'

class Tables::Enumerations < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, limit: 30, default: '', null: false
      t.integer :position, default: 1
      t.boolean :is_default, default: false, null: false
      t.string :type
      t.boolean :active, default: true, null: false
      t.integer :project_id
      t.integer :parent_id

      t.index %i[id type], name: 'index_enumerations_on_id_and_type'
      t.index :project_id, name: 'index_enumerations_on_project_id'
    end
  end
end
