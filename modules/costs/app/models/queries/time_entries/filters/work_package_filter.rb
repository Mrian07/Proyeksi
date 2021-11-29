#-- encoding: UTF-8



class Queries::TimeEntries::Filters::WorkPackageFilter < Queries::TimeEntries::Filters::TimeEntryFilter
  def allowed_values
    @allowed_values ||= begin
      # We don't care for the first value as we do not display the values visibly
      ::WorkPackage.visible.pluck(:id).map { |id| [id, id.to_s] }
    end
  end

  def type
    :list_optional
  end

  def self.key
    :work_package_id
  end
end
