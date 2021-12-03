#-- encoding: UTF-8

class Queries::WorkPackages::Filter::AssignedToFilter <
  Queries::WorkPackages::Filter::PrincipalBaseFilter
  def type
    :list_optional
  end

  def human_name
    WorkPackage.human_attribute_name('assigned_to')
  end

  def self.key
    :assigned_to_id
  end
end
