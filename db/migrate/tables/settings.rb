require_relative 'base'

class Tables::Settings < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :name, default: '', null: false
      t.text :value
      t.datetime :updated_on

      t.index :name, name: 'index_settings_on_name'
    end
  end
end
