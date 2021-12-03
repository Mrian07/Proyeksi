#-- encoding: UTF-8

class RemoveTimelinesAndReportings < ActiveRecord::Migration[5.0]
  def up
    drop_table :timelines
    drop_table :reportings
    drop_table :available_project_statuses

    delete_reported_project_statuses

    remove_column :project_types, :allows_association
  end

  def down
    create_reportings
    create_timelines
    create_available_project_statuses

    add_column :project_types, :allows_association, :boolean, default: true, null: false
  end

  private

  def create_reportings
    create_table(:reportings, id: :integer) do |t|
      t.column :reported_project_status_comment, :text

      t.belongs_to :project
      t.belongs_to :reporting_to_project
      t.belongs_to :reported_project_status

      t.timestamps
    end
  end

  def create_timelines
    create_table :timelines, id: :integer do |t|
      t.column :name, :string, null: false
      t.column :options, :text

      t.belongs_to :project

      t.timestamps
    end
  end

  def create_available_project_statuses
    create_table(:available_project_statuses, id: :integer) do |t|
      t.belongs_to :project_type
      t.belongs_to :reported_project_status, index: { name: 'index_avail_project_statuses_on_rep_project_status_id' }

      t.timestamps
    end
  end

  def delete_reported_project_statuses
    delete <<-SQL
      DELETE FROM enumerations
      WHERE type = 'ReportedProjectStatus'
    SQL
  end
end
