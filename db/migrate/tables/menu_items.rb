

require_relative 'base'

class Tables::MenuItems < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.column :name, :string
      t.column :title, :string
      t.column :parent_id, :integer
      t.column :options, :text
      t.belongs_to :navigatable, type: :int, index: false
      t.string :type

      t.index %i(navigatable_id title)
      t.index :parent_id
    end
  end
end
