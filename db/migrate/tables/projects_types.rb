

require_relative 'base'

class Tables::ProjectsTypes < Tables::Base
  def self.id_options
    { id: false }
  end

  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, default: 0, null: false
      t.integer :type_id, default: 0, null: false

      t.index :project_id,
              name: :projects_types_project_id
      t.index %i[project_id type_id],
              name: :projects_types_unique, unique: true
    end
  end
end
