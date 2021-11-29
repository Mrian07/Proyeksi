#-- encoding: UTF-8



class Activities::TimeEntryActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'time_entries',
                        permission: :view_time_entries

  def extend_event_query(query)
    query.join(work_packages_table).on(activity_journals_table[:work_package_id].eq(work_packages_table[:id]))
    query.join(types_table).on(work_packages_table[:type_id].eq(types_table[:id]))
    query.join(statuses_table).on(work_packages_table[:status_id].eq(statuses_table[:id]))
  end

  def event_query_projection
    [
      activity_journal_projection_statement(:hours, 'time_entry_hours'),
      activity_journal_projection_statement(:comments, 'time_entry_comments'),
      activity_journal_projection_statement(:project_id, 'project_id'),
      activity_journal_projection_statement(:work_package_id, 'work_package_id'),
      projection_statement(projects_table, :name, 'project_name'),
      projection_statement(work_packages_table, :subject, 'work_package_subject'),
      projection_statement(statuses_table, :name, 'status_name'),
      projection_statement(statuses_table, :is_closed, 'status_closed'),
      projection_statement(types_table, :name, 'type_name')
    ]
  end

  protected

  def event_title(event)
    time_entry_object_name = event['work_package_id'].blank? ? event['project_name'] : work_package_title(event)
    "#{l_hours(event['time_entry_hours'])} (#{time_entry_object_name})"
  end

  def event_type(_event)
    'time-entry'
  end

  def work_package_title(event)
    Activities::WorkPackageActivityProvider.work_package_title(event['work_package_id'],
                                                               event['work_package_subject'],
                                                               event['type_name'],
                                                               event['status_name'],
                                                               event['is_standard'])
  end

  def event_description(event)
    event['time_entry_description']
  end

  def event_path(event)
    event_location(event)
  end

  def event_url(event)
    event_location(event, only_path: false)
  end

  def types_table
    @types_table = Type.arel_table
  end

  def statuses_table
    @statuses_table = Status.arel_table
  end

  def work_packages_table
    @work_packages_table ||= WorkPackage.arel_table
  end

  def event_location(event, only_path: true)
    filter_params = if event['work_package_id'].present?
                      work_package_id_filter(event['work_package_id'])
                    else
                      project_id_filter(event['project_id'])
                    end

    url_helpers.cost_reports_url(event['project_id'], only_path: only_path, **filter_params)
  end

  def project_id_filter(project_id)
    { 'fields[]': 'ProjectId', 'operators[ProjectId]': '=', 'values[ProjectId]': project_id, set_filter: 1 }
  end

  def work_package_id_filter(work_package_id)
    { 'fields[]': 'WorkPackageId', 'operators[WorkPackageId]': '=', 'values[WorkPackageId]': work_package_id, set_filter: 1 }
  end
end
