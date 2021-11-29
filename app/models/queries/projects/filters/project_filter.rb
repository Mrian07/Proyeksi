#-- encoding: UTF-8



class Queries::Projects::Filters::ProjectFilter < Queries::Filters::Base
  self.model = Project

  def human_name
    Project.human_attribute_name(name)
  end
end
