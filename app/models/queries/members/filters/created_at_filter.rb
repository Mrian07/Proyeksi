#-- encoding: UTF-8

class Queries::Members::Filters::CreatedAtFilter < Queries::Members::Filters::MemberFilter
  def type
    :datetime_past
  end
end
