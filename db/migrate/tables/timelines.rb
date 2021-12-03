require_relative 'base'

class Tables::Timelines < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, null: false
      t.belongs_to :project, type: :int
      t.timestamps null: true
      t.text :options
    end
  end
end
