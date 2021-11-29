

require_relative 'base'

class Tables::ProjectTypes < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.column :name, :string, default: '', null: false
      t.column :allows_association, :boolean, default: true, null: false
      t.column :position, :integer, default: 1, null: true

      t.timestamps null: true
    end
  end
end
