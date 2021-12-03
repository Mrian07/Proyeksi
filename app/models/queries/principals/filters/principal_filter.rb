#-- encoding: UTF-8

class Queries::Principals::Filters::PrincipalFilter < Queries::Filters::Base
  self.model = Principal

  def human_name
    Principal.human_attribute_name(name)
  end
end
