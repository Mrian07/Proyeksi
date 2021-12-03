#-- encoding: UTF-8

class Projects::Status < ActiveRecord::Base
  belongs_to :project

  self.table_name = 'project_statuses'

  validates :project,
            presence: true,
            uniqueness: true

  enum code: %i[on_track at_risk off_track]
end
