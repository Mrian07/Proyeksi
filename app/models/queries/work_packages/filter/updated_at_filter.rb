#-- encoding: UTF-8

class Queries::WorkPackages::Filter::UpdatedAtFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :datetime_past
  end
end
