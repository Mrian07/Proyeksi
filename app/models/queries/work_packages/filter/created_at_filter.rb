#-- encoding: UTF-8

class Queries::WorkPackages::Filter::CreatedAtFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :datetime_past
  end
end
