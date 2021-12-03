require_relative 'base'

class Tables::Relations < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :from_id, null: false
      t.integer :to_id, null: false
      t.string :relation_type, default: '', null: false
      t.integer :delay
      t.text :description

      t.index :from_id, name: 'index_relations_on_from_id'
      t.index :to_id, name: 'index_relations_on_to_id'
    end
  end
end
