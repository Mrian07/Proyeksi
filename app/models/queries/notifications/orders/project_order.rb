#-- encoding: UTF-8

class Queries::Notifications::Orders::ProjectOrder < Queries::Orders::Base
  self.model = Notification

  def self.key
    :project
  end

  def joins
    :project
  end

  protected

  def order
    order_string = "projects.name"
    order_string += " DESC" if direction == :desc

    model.order(order_string)
  end
end
