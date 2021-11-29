

require_relative 'base'

class Tables::Types < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, default: '', null: false
      t.integer :position, default: 1
      t.boolean :is_in_roadmap, default: true, null: false
      t.boolean :in_aggregation, default: true, null: false
      t.boolean :is_milestone, default: false, null: false
      t.boolean :is_default, default: false, null: false
      t.belongs_to :color, type: :int, index: { name: :index_types_on_color_id }
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.boolean :is_standard, default: false, null: false
      t.text :attribute_visibility, hash: true
      t.text :attribute_groups
    end
  end
end
