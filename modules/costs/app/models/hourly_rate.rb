

class HourlyRate < Rate
  validates_uniqueness_of :valid_from, scope: %i[user_id project_id]
  validates_presence_of :user_id, :project_id, :valid_from
  validate :change_of_user_only_on_first_creation

  def previous(reference_date = valid_from)
    # This might return a default rate
    user.rate_at(reference_date - 1, project)
  end

  def next(reference_date = valid_from)
    HourlyRate
      .where(['user_id = ? and project_id = ? and valid_from > ?',
              user_id, project_id, reference_date])
      .order(Arel.sql('valid_from ASC'))
      .first
  end

  def self.history_for_user(usr)
    projects_with_costs = Project.has_module(:costs)
                                        .active
                                        .visible
                                        .order(:name)

    permitted_projects = Project.has_module(:costs)
                                .active
                                .allowed_to(User.current, :view_hourly_rates)

    rates_by_project = HourlyRate.where(user_id: usr, project_id: permitted_projects)
                                 .includes(:project)
                                 .order("#{HourlyRate.table_name}.valid_from desc")
                                 .group_by(&:project)

    rates = {}

    projects_with_costs.each do |project|
      rates[project] = rates_by_project.fetch(project, [])
    end

    # FIXME: What permissions to apply here?
    rates[nil] = DefaultHourlyRate
                   .where(user_id: usr)
                   .order("#{DefaultHourlyRate.table_name}.valid_from desc")

    rates
  end

  def self.at_date_for_user_in_project(date, user_id, project = nil, include_default = true)
    user_id = user_id.id if user_id.is_a?(User)

    unless project.nil?
      rate = where(['user_id = ? and project_id = ? and valid_from <= ?', user_id, project, date])
             .order(Arel.sql('valid_from DESC'))
             .first
      if rate.nil?
        project = Project.find(project) unless project.is_a?(Project)
        rate = where(['user_id = ? and project_id in (?) and valid_from <= ?',
                      user_id,
                      project.ancestors.to_a,
                      date])
               .includes(:project)
               .order(Arel.sql('projects.lft DESC, valid_from DESC'))
               .first
      end
    end
    rate ||= DefaultHourlyRate.at_for_user(date, user_id) if include_default
    rate
  end

  private

  def change_of_user_only_on_first_creation
    # Only allow change of project and user on first creation
    return if new_record?

    errors.add :project_id, :invalid if project_id_changed?
    errors.add :user_id, :invalid if user_id_changed?
  end
end
