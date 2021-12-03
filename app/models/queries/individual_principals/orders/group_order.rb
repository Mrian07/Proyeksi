#-- encoding: UTF-8

class Queries::IndividualPrincipals::Orders::GroupOrder < Queries::Orders::Base
  self.model = Principal

  def self.key
    :group
  end

  private

  def order
    order_string = "groups_users.lastname"

    order_string += " DESC" if direction == :desc

    model.order(order_string)
  end

  def joins
    :groups
  end
end
