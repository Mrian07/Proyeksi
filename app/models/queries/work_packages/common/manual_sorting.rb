#-- encoding: UTF-8

module Queries::WorkPackages
  module Common
    module ManualSorting
      ##
      # We depend on ordered_work_packages association
      # for determining sort and filter for manual sorting.
      #
      # We could restrict the join result with where(query_id: context.id) later
      # but that prevents the execution planner from optimizing on the explicit join clause.
      def ordered_work_packages_join(query)
        join_sql = <<-SQL
          LEFT OUTER JOIN
            ordered_work_packages
          ON
            ordered_work_packages.work_package_id = work_packages.id
            AND ordered_work_packages.query_id = :query_id
        SQL

        ::ProyeksiApp::SqlSanitization
          .sanitize join_sql, query_id: query.id
      end
    end
  end
end
