#-- encoding: UTF-8



class Queries::TimeEntries::Filters::UserFilter < Queries::TimeEntries::Filters::TimeEntryFilter
  include Queries::Filters::Shared::MeValueFilter

  def allowed_values
    @allowed_values ||= begin
      # We don't care for the first value as we do not display the values visibly
      me_allowed_value + ::Principal
                         .in_visible_project
                         .pluck(:id)
                         .map { |id| [id, id.to_s] }
    end
  end

  def where
    operator_strategy.sql_for_field(values_replaced, self.class.model.table_name, self.class.key)
  end

  def type
    :list_optional
  end

  def self.key
    :user_id
  end
end
