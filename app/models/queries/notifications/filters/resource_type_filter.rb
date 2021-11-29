#-- encoding: UTF-8



class Queries::Notifications::Filters::ResourceTypeFilter < Queries::Notifications::Filters::NotificationFilter
  def allowed_values
    [[WorkPackage.name, WorkPackage.name]]
  end

  def type
    :list
  end
end
