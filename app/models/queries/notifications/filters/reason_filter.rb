#-- encoding: UTF-8

class Queries::Notifications::Filters::ReasonFilter < Queries::Notifications::Filters::NotificationFilter
  def allowed_values
    Notification.reasons.keys.map { |reason| [reason, reason] }
  end

  def type
    :list
  end

  def where
    id_values = values.map { |value| Notification.reasons[value] }
    operator_strategy.sql_for_field(id_values, self.class.model.table_name, :reason)
  end
end
