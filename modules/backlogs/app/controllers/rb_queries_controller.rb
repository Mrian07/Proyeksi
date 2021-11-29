

class RbQueriesController < RbApplicationController
  include WorkPackagesFilterHelper

  def show
    filters = []
    if @sprint_id
      filters.push(filter_object('status_id', '*'))
      filters.push(filter_object('version_id', '=', [@sprint_id]))
    # Note: We need a filter for backlogs_work_package_type but currently it's not possible for plugins to introduce new filter types
    else
      filters.push(filter_object('status_id', 'o'))
      filters.push(filter_object('version_id', '!*', [@sprint_id]))
      # Same as above
    end

    query = {
      f: filters,
      c: ['type', 'status', 'priority', 'subject', 'assigned_to', 'updated_at', 'position'],
      t: 'position:desc'
    }

    redirect_to project_work_packages_with_query_path(@project, query)
  end
end
