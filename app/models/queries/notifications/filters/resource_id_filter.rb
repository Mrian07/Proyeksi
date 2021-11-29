#-- encoding: UTF-8



class Queries::Notifications::Filters::ResourceIdFilter < Queries::Notifications::Filters::NotificationFilter
  def allowed_values
    WorkPackage
      .visible(User.current)
      .pluck(:id, :id)
  end

  def type
    :list
  end
end
