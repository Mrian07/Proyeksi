#-- encoding: UTF-8



class Queries::Members::Orders::NameOrder < Queries::Orders::Base
  self.model = Member

  def self.key
    :name
  end

  def joins
    :principal
  end

  protected

  def order
    model.merge Principal.ordered_by_name(desc: direction == :desc)
  end
end
