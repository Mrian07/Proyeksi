#-- encoding: UTF-8



module WorkPackages::Scopes::IncludeSpentTime
  extend ActiveSupport::Concern

  class_methods do
    def include_spent_time(user, work_package = nil)
      query = join_time_entries(user)

      scope = left_join_self_and_descendants(user, work_package)
              .joins(query.join_sources)
              .group(:id)
              .select('SUM(time_entries.hours) AS hours')

      if work_package
        scope.where(id: work_package.id)
      else
        scope
      end
    end

    protected

    def join_time_entries(user)
      join_condition = time_entries_table[:work_package_id]
                       .eq(wp_descendants[:id])
                       .and(allowed_to_view_time_entries(user))

      wp_table
        .outer_join(time_entries_table)
        .on(join_condition)
    end

    def allowed_to_view_time_entries(user)
      time_entries_table[:id].in(TimeEntry.visible(user).select(:id).arel)
    end

    def wp_table
      @wp_table ||= arel_table
    end

    def wp_descendants
      # Relies on a table called descendants to exist in the scope
      # which is provided by left_join_self_and_descendants
      @wp_descendants ||= wp_table.alias('descendants')
    end

    def time_entries_table
      @time_entries_table ||= TimeEntry.arel_table
    end
  end
end
