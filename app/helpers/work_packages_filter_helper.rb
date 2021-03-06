#-- encoding: UTF-8

module WorkPackagesFilterHelper
  # Links for project overview
  def project_work_packages_closed_version_path(version, options = {})
    query = {
      f: [
        filter_object('status_id', 'c'),
        filter_object('version_id', '=', version.id)
      ]
    }
    project_work_packages_with_query_path(version.project, query, options)
  end

  def project_work_packages_open_version_path(version, options = {})
    query = {
      f: [
        filter_object('status_id', 'o'),
        filter_object('version_id', '=', version.id)
      ]
    }
    project_work_packages_with_query_path(version.project, query, options)
  end

  # Links for reports

  def project_report_property_path(project, property_name, property_id, options = {})
    query = {
      f: [
        filter_object('status_id', '*'),
        filter_object('subproject_id', '!*'),
        filter_object(property_name, '=', property_id)
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query, options)
  end

  def project_report_property_status_path(project, status_id, property, property_id, options = {})
    query = {
      f: [
        filter_object('status_id', '=', status_id),
        filter_object('subproject_id', '!*'),
        filter_object(property, '=', property_id)
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query, options)
  end

  def project_report_property_open_path(project, property, property_id, options = {})
    query = {
      f: [
        filter_object('status_id', 'o'),
        filter_object('subproject_id', '!*'),
        filter_object(property, '=', property_id)
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query, options)
  end

  def project_report_property_closed_path(project, property, property_id, options = {})
    query = {
      f: [
        filter_object('status_id', 'c'),
        filter_object('subproject_id', '!*'),
        filter_object(property, '=', property_id)
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(project, query, options)
  end

  def project_version_property_path(version, property_name, property_id, options = {})
    query = {
      f: [
        filter_object('status_id', '*'),
        filter_object('version_id', '=', version.id),
        filter_object(property_name, '=', property_id)
      ],
      t: default_sort
    }
    project_work_packages_with_query_path(version.project, query, options)
  end

  private

  def default_sort
    'updated_at:desc'
  end

  def project_work_packages_with_query_path(project, query, options = {})
    project_work_packages_path(project, options.reverse_merge!(query_props: query.to_json))
  end

  def filter_object(property, operator, values = nil)
    v3_property = API::Utilities::PropertyNameConverter.from_ar_name(property)
    values = filter_values(values) if values

    {
      n: v3_property,
      o: operator,
      v: values
    }.compact
  end

  def filter_values(values)
    if values.is_a? Array
      values.map(&:to_s)
    else
      values.to_s
    end
  end
end
