#-- encoding: UTF-8

require_relative 'base'

class Tables::CustomOptions < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :custom_field_id
      t.integer :position
      t.boolean :default_value
      t.text :value
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
