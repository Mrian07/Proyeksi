#-- encoding: UTF-8



class Queries::TimeEntries::Filters::ActivityFilter < Queries::TimeEntries::Filters::TimeEntryFilter
  def allowed_values
    @allowed_values ||= begin
      # To mask the internal complexity of time entries and to
      # allow filtering by a combined value only shared activities are
      # valid values
      ::TimeEntryActivity
        .shared
        .pluck(:name, :id)
    end
  end

  def type
    :list_optional
  end

  def self.key
    :activity_id
  end

  def where
    # Because the project specific activity is used for storing the time entry,
    # we have to deduce the actual filter value which is the id of all the provided activities' children.
    # But when the activity itself is already shared, we use that value.
    db_values = child_values
                .or(shared_values)
                .pluck(:id)

    operator_strategy.sql_for_field(db_values, self.class.model.table_name, self.class.key)
  end

  private

  def child_values
    TimeEntryActivity
      .where(parent_id: values)
  end

  def shared_values
    TimeEntryActivity
      .shared
      .where(id: values)
  end
end
