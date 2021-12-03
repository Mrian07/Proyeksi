require_relative 'base'

class Tables::DesignColors < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :variable
      t.string :hexcode

      t.timestamps

      t.index :variable, unique: true
    end
  end
end
