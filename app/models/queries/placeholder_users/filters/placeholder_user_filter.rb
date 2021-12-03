#-- encoding: UTF-8

class Queries::PlaceholderUsers::Filters::PlaceholderUserFilter < Queries::Filters::Base
  self.model = PlaceholderUser

  def human_name
    User.human_attribute_name(name)
  end
end
