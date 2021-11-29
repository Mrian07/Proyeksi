#-- encoding: UTF-8



class Queries::Notifications::Filters::IdFilter < Queries::Notifications::Filters::NotificationFilter
  def allowed_values
    Notification
      .recipient(User.current)
      .pluck(:id, :id)
  end

  def type
    :list
  end

  def self.key
    :id
  end
end
