#-- encoding: UTF-8

class Queries::WorkPackages::Filter::SubjectFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :text
  end
end
