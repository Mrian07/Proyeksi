#-- encoding: UTF-8

class Queries::Projects::Filters::IdFilter < Queries::Projects::Filters::ProjectFilter
  def type
    :integer
  end
end
