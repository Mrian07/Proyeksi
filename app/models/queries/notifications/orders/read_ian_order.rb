#-- encoding: UTF-8

class Queries::Notifications::Orders::ReadIanOrder < Queries::Orders::Base
  self.model = Notification

  def self.key
    :read_ian
  end
end
