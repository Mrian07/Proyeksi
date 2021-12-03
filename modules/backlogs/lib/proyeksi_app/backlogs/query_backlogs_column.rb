

module ProyeksiApp::Backlogs
  class QueryBacklogsColumn < Queries::WorkPackages::Columns::WorkPackageColumn
    class_attribute :backlogs_columns

    self.backlogs_columns = {
      story_points: {
        sortable: "#{WorkPackage.table_name}.story_points",
        summable: true
      },
      remaining_hours: {
        sortable: "#{WorkPackage.table_name}.remaining_hours",
        summable: true
      },
      position: {
        default_order: 'asc',
        # Sort by position only, always show work_packages without a position at the end
        sortable: "CASE WHEN #{WorkPackage.table_name}.position IS NULL THEN 1 ELSE 0 END ASC, #{WorkPackage.table_name}.position"
      }
    }

    def self.instances(context = nil)
      return [] if context && !context.backlogs_enabled?

      backlogs_columns.map do |name, options|
        new(name, options)
      end
    end
  end
end
