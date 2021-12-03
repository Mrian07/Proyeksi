#-- encoding: UTF-8

class Queries::Projects::Filters::CreatedAtFilter < Queries::Projects::Filters::ProjectFilter
  def type
    :datetime_past
  end

  def available?
    User.current.admin?
  end
end
