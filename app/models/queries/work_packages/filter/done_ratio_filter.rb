#-- encoding: UTF-8



class Queries::WorkPackages::Filter::DoneRatioFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :integer
  end
end
