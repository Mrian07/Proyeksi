#-- encoding: UTF-8



class Queries::WorkPackages::Columns::ManualSortingColumn < Queries::WorkPackages::Columns::WorkPackageColumn
  include ::Queries::WorkPackages::Common::ManualSorting

  def initialize
    super :manual_sorting,
          default_order: 'asc',
          sortable: "#{OrderedWorkPackage.table_name}.position NULLS LAST, #{WorkPackage.table_name}.id"
  end

  def sortable_join_statement(query)
    ordered_work_packages_join(query)
  end
end
