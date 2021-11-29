#-- encoding: UTF-8



class Queries::Notifications::GroupBys::GroupByProject < Queries::GroupBys::Base
  self.model = Notification

  def self.key
    :project
  end

  def name
    :project_id
  end

  def association_class
    Project
  end
end
