#-- encoding: UTF-8

class Queries::WorkPackages::Filter::DueDateFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :date
  end
end
