#-- encoding: UTF-8

class Queries::Notifications::Orders::ReasonOrder < Queries::Orders::Base
  self.model = Notification

  def self.key
    :reason
  end

  def name
    :reason
  end
end
