#-- encoding: UTF-8



class Queries::Versions::Orders::NameOrder < Queries::Orders::Base
  self.model = Version

  def self.key
    :name
  end

  private

  def order
    ordered = Version.order_by_name

    if direction == :desc
      ordered = ordered.reverse_order
    end

    ordered
  end
end
