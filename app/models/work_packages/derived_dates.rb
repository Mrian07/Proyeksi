#-- encoding: UTF-8



module WorkPackages::DerivedDates
  # Returns the maximum of the dates of all descendants (start and due date)
  # No visibility check is applied so a user will always see the maximum regardless of his permission.
  #
  # The value can stem from either eager loading the value via
  # WorkPackage.include_derived_dates in which case the work package has a
  # derived_start_date attribute or it is loaded on calling the method.
  def derived_start_date
    derived_date('derived_start_date')
  end

  # Returns the minimum of the dates of all descendants (start and due date)
  # No visibility check is applied so a user will always see the minimum regardless of his permission.
  #
  # The value can stem from either eager loading the value via
  # WorkPackage.include_derived_dates in which case the work package has a
  # derived_due_date attribute or it is loaded on calling the method.
  def derived_due_date
    derived_date('derived_due_date')
  end

  def derived_start_date=(date)
    compute_derived_dates
    @derived_dates[0] = date
  end

  def derived_due_date=(date)
    compute_derived_dates
    @derived_dates[1] = date
  end

  def reload(*)
    @derived_dates = nil
    super
  end

  private

  def derived_date(key)
    if attributes.key?(key)
      attributes[key]
    else
      compute_derived_dates[key]
    end
  end

  def compute_derived_dates
    @derived_dates ||= begin
      attributes = %w[derived_start_date derived_due_date]

      values = if persisted?
                 WorkPackage
                   .from(WorkPackage.include_derived_dates.where(id: self))
                   .pluck(*attributes.each { |a| Arel.sql(a) })
                   .first || []
               else
                 []
               end

      attributes
        .zip(values)
        .to_h
    end
  end
end
