#-- encoding: UTF-8

class Queries::Queries::Filters::QueryFilter < Queries::Filters::Base
  self.model = Query

  def human_name
    Query.human_attribute_name(name)
  end
end
