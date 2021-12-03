#-- encoding: UTF-8

class Queries::WorkPackages::Filter::EstimatedHoursFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :integer
  end

  def where
    if operator == Queries::Operators::None.to_sym.to_s
      super + " OR #{WorkPackage.table_name}.estimated_hours=0"
    else
      super
    end
  end
end
