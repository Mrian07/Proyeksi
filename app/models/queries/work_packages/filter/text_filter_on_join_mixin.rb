#-- encoding: UTF-8



module Queries::WorkPackages::Filter::TextFilterOnJoinMixin
  def where
    case operator
    when '~'
      "EXISTS (#{where_condition})"
    when '!~'
      "NOT EXISTS (#{where_condition})"
    else
      raise 'Unsupported operator'
    end
  end
end
