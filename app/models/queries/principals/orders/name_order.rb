#-- encoding: UTF-8

class Queries::Principals::Orders::NameOrder < Queries::Orders::Base
  self.model = Principal

  def self.key
    :name
  end

  protected

  def order
    model.ordered_by_name(desc: direction == :desc)
  end
end
