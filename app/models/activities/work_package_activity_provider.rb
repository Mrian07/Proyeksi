#-- encoding: UTF-8

class Activities::WorkPackageActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'work_packages',
                        permission: :view_work_packages

  def extend_event_query(query)
    query.join(types_table).on(activity_journals_table[:type_id].eq(types_table[:id]))
    query.join(statuses_table).on(activity_journals_table[:status_id].eq(statuses_table[:id]))
  end

  def event_query_projection
    [
      activity_journal_projection_statement(:subject, 'subject'),
      activity_journal_projection_statement(:project_id, 'project_id'),
      projection_statement(statuses_table, :name, 'status_name'),
      projection_statement(statuses_table, :is_closed, 'status_closed'),
      projection_statement(types_table, :name, 'type_name')
    ]
  end

  def self.work_package_title(id, subject, type_name, status_name, is_standard)
    title = "#{is_standard ? '' : type_name.to_s} ##{id}: #{subject}"
    title << " (#{status_name})" unless status_name.blank?
  end

  protected

  def event_title(event)
    self.class.work_package_title(event['journable_id'],
                                  event['subject'],
                                  event['type_name'],
                                  event['status_name'],
                                  event['is_standard'])
  end

  def event_type(event)
    state = ActiveRecord::Type::Boolean.new.cast(event['status_closed']) ? '-closed' : '-edit'

    "work_package#{state}"
  end

  def event_path(event)
    url_helpers.work_package_path(event['journable_id'])
  end

  def event_url(event)
    url_helpers.work_package_url(event['journable_id'],
                                 anchor: notes_anchor(event))
  end

  private

  def notes_anchor(event)
    version = event['version'].to_i

    version > 1 ? "note-#{version - 1}" : ''
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
end
