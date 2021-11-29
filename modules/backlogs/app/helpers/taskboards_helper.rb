

module TaskboardsHelper
  def impediments_by_position_for_status(sprint, project, status)
    @impediments_by_position_for_status ||= sprint.impediments(project).group_by(&:status_id)

    (@impediments_by_position_for_status[status.id] || [])
      .sort_by { |i| i.position.present? ? i.position : 0 }
  end
end
