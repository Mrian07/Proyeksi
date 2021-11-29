#-- encoding: UTF-8



class TimeEntryActivity < Enumeration
  include ::Scopes::Scoped

  has_many :time_entries, foreign_key: 'activity_id'
  has_many :time_entry_activities_projects, foreign_key: 'activity_id', dependent: :delete_all

  validates :parent, absence: true

  OptionName = :enumeration_activities

  scopes :active_in_project

  def option_name
    OptionName
  end

  def objects_count
    time_entries.count
  end

  def transfer_relations(to)
    time_entries.update_all(activity_id: to.id)
  end

  def active_in_project?(project)
    teap = if time_entry_activities_projects.loaded?
             detect_project_time_entry_activity_active_state(project)
           else
             pluck_project_time_entry_activity_active_state(project)
           end

    !teap.nil? && teap || teap.nil? && active?
  end

  def activated_projects
    Project.activated_time_activity(self)
  end

  private

  def detect_project_time_entry_activity_active_state(project)
    time_entry_activities_projects.detect { |t| t.project_id == project.id }&.active?
  end

  def pluck_project_time_entry_activity_active_state(project)
    time_entry_activities_projects
      .where(project_id: project.id)
      .pluck(:active)
      .first
  end
end
