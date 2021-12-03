#-- encoding: UTF-8

class Queries::Queries::Filters::UpdatedAtFilter < Queries::Queries::Filters::QueryFilter
  def type
    :datetime_past
  end
end
