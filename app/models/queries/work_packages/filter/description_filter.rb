#-- encoding: UTF-8

class Queries::WorkPackages::Filter::DescriptionFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :text
  end
end
