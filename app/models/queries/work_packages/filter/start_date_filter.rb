#-- encoding: UTF-8

class Queries::WorkPackages::Filter::StartDateFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :date
  end
end
