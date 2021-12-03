#-- encoding: UTF-8

class Queries::WorkPackages::Filter::DatesIntervalFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::Operators::DateRangeClauses

  def type
    :date
  end

  def where
    lower_boundary, upper_boundary = values.map { |v| v.blank? ? nil : Date.parse(v) }

    <<-SQL
      (work_packages.start_date < '#{quoted_date_from_utc(lower_boundary)}' AND
       work_packages.due_date > '#{quoted_date_from_utc(lower_boundary)}') OR
      (#{date_range_clause('work_packages', 'start_date', lower_boundary, upper_boundary)}) OR
      (#{date_range_clause('work_packages', 'due_date', lower_boundary, upper_boundary)})
    SQL
  end

  def type_strategy
    @type_strategy ||= Queries::Filters::Strategies::DateInterval.new(self)
  end

  def connection
    ActiveRecord::Base::connection
  end
end
