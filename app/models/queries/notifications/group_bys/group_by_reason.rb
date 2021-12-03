#-- encoding: UTF-8

class Queries::Notifications::GroupBys::GroupByReason < Queries::GroupBys::Base
  self.model = Notification

  def self.key
    :reason
  end

  def name
    :reason
  end
end
