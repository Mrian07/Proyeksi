#-- encoding: UTF-8

module WorkPackages::SpentTime
  # Returns the total number of hours spent on this work package and its descendants.
  # The result can be a subset of the actual spent time in cases where the user's permissions
  # are limited, i.e. he lacks the view_time_entries and/or view_work_packages permission.
  #
  # Example:
  #   spent_hours => 0.0
  #   spent_hours => 50.2
  #
  #   The value can stem from either eager loading the value via
  #   WorkPackage.include_spent_time in which case the work package has an
  #   #hours attribute or it is loaded on calling the method.
  def spent_hours(user = User.current)
    if respond_to?(:hours)
      hours.to_f
    else
      compute_spent_hours(user)
    end || 0.0
  end

  private

  def compute_spent_hours(user)
    WorkPackage.include_spent_time(user, self)
               .pluck(Arel.sql('SUM(hours)'))
               .first
  end
end
