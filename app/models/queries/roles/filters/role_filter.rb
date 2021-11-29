#-- encoding: UTF-8



class Queries::Roles::Filters::RoleFilter < Queries::Filters::Base
  self.model = Role

  def human_name
    Role.human_attribute_name(name)
  end
end
