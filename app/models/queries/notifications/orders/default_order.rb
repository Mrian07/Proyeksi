#-- encoding: UTF-8



class Queries::Notifications::Orders::DefaultOrder < Queries::Orders::Base
  self.model = Notification

  def self.key
    /\A(id|created_at|updated_at)\z/
  end
end
