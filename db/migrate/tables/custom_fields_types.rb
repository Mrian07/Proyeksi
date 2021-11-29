#-- encoding: UTF-8



require_relative 'base'

class Tables::CustomFieldsTypes < Tables::Base
  def self.id_options
    { id: false }
  end

  def self.table(migration)
    create_table migration do |t|
      t.integer :custom_field_id, default: 0, null: false
      t.integer :type_id, default: 0, null: false

      t.index %i[custom_field_id type_id],
              name: :custom_fields_types_unique,
              unique: true
    end
  end
end
