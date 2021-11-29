

require_relative 'base'

class Tables::CustomStyles < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :logo
      t.timestamps
      t.string :favicon
      t.string :touch_icon
    end
  end
end
