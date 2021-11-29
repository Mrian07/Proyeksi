

require_relative 'base'

class Tables::ProjectAssociations < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.belongs_to :project_a, type: :int
      t.belongs_to :project_b, type: :int

      t.column :description, :text

      t.timestamps null: true
    end
  end
end
