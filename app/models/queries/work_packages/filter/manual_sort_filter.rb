#-- encoding: UTF-8



class Queries::WorkPackages::Filter::ManualSortFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Common::ManualSorting

  def available_operators
    [Queries::Operators::OrderedWorkPackages]
  end

  def available?
    true
  end

  def type
    :empty_value
  end

  def where
    WorkPackage
      .arel_table[:id]
      .in(context.ordered_work_packages.pluck(:work_package_id))
      .to_sql
  end

  def self.key
    :manual_sort
  end

  def ar_object_filter?
    true
  end

  private

  def operator_strategy
    Queries::Operators::OrderedWorkPackages
  end
end
