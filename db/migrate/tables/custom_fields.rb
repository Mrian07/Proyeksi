#-- encoding: UTF-8

require_relative 'base'

class Tables::CustomFields < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.string :type, limit: 30, default: '', null: false
      t.string :field_format, limit: 30, default: '', null: false
      t.string :regexp, default: ''
      t.integer :min_length, default: 0, null: false
      t.integer :max_length, default: 0, null: false
      t.boolean :is_required, default: false, null: false
      t.boolean :is_for_all, default: false, null: false
      t.boolean :is_filter, default: false, null: false
      t.integer :position, default: 1
      t.boolean :searchable, default: false
      t.boolean :editable, default: true
      t.boolean :visible, default: true, null: false
      t.boolean :multi_value, default: false
      t.text :default_value
      t.string :name, limit: 255, default: nil
      t.datetime :created_at
      t.datetime :updated_at

      t.index %i[id type], name: 'index_custom_fields_on_id_and_type'
    end
  end

  # rubocop:enable Metrics/AbcSize
end
