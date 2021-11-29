#-- encoding: UTF-8



class Queries::Members::Filters::GroupFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::GroupFilter

  def joins
    nil
  end

  def scope
    scope = model.joins(:principal).merge(User.joins(:groups))
    scope.where(where)
  end
end
