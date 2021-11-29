

require_relative 'base'

class Tables::AvailableProjectStatuses < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.belongs_to :project_type, type: :int
      t.belongs_to :reported_project_status, type: :int, index: { name: 'index_avail_project_statuses_on_rep_project_status_id' }

      t.timestamps null: true # compatibility to pre 5.1 migrations
    end
  end
end
