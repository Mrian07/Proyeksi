#-- encoding: UTF-8



class Queries::WorkPackages::Filter::VersionFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    @allowed_values ||= begin
      # as we no longer display the allowed values, the first value is irrelevant
      versions.pluck(:id).map { |id| [id.to_s, id.to_s] }
    end
  end

  def type
    :list_optional
  end

  def human_name
    WorkPackage.human_attribute_name('version')
  end

  def self.key
    :version_id
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_versions = versions.index_by(&:id)

    values
      .map { |version_id| available_versions[version_id.to_i] }
      .compact
  end

  private

  def versions
    if project
      project.shared_versions
    else
      Version.visible.systemwide
    end
  end
end
