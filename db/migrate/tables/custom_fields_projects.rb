#-- encoding: UTF-8

require_relative 'base'

class Tables::CustomFieldsProjects < Tables::Base
  def self.id_options
    { id: false }
  end

  def self.table(migration)
    create_table migration do |t|
      t.integer :custom_field_id, default: 0, null: false
      t.integer :project_id, default: 0, null: false

      t.index %i[custom_field_id project_id],
              name: 'index_custom_fields_projects_on_custom_field_id_and_project_id'
    end
  end
end
