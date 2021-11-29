

require_relative 'base'

class Tables::PlanningElementTypeColors < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.column :name, :string, null: false
      t.column :hexcode, :string, null: false, length: 7

      t.integer :position, default: 1, null: true

      t.timestamps null: true
    end
  end
end
