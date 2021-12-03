#-- encoding: UTF-8

class Queries::Notifications::NotificationQuery < Queries::BaseQuery
  def self.model
    Notification
  end

  def default_scope
    Notification.recipient(user)
  end
end
