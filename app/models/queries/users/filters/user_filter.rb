#-- encoding: UTF-8

class Queries::Users::Filters::UserFilter < Queries::Filters::Base
  self.model = User.user

  def human_name
    User.human_attribute_name(name)
  end
end
