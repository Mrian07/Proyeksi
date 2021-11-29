#-- encoding: UTF-8



class Queries::Notifications::Filters::NotificationFilter < Queries::Filters::Base
  self.model = Notification

  def human_name
    Notification.human_attribute_name(name)
  end
end
