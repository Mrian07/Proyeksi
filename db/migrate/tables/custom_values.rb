#-- encoding: UTF-8

require_relative 'base'

class Tables::CustomValues < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :customized_type, limit: 30, default: '', null: false
      t.integer :customized_id, default: 0, null: false
      t.integer :custom_field_id, default: 0, null: false
      t.text :value

      t.index :custom_field_id, name: 'index_custom_values_on_custom_field_id'
      t.index %i[customized_type customized_id], name: 'custom_values_customized'
    end
  end
end
