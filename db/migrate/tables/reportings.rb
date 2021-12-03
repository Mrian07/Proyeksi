require_relative 'base'

class Tables::Reportings < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.column :reported_project_status_comment, :text

      t.belongs_to :project, type: :int
      t.belongs_to :reporting_to_project, type: :int
      t.belongs_to :reported_project_status, type: :int

      t.timestamps null: true
    end
  end
end
