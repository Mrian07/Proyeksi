#-- encoding: UTF-8

class Queries::Members::Orders::EmailOrder < Queries::Orders::Base
  self.model = Member

  def self.key
    :mail
  end

  def joins
    :principal
  end

  private

  def order
    with_raise_on_invalid do
      order_string = "NULLIF(mail, '')"
      order_string += " DESC" if direction == :desc
      order_string += " NULLS LAST"

      model.order(Arel.sql(order_string))
    end
  end
end
