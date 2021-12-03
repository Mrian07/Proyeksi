#-- encoding: UTF-8

class Queries::Actions::Filters::ActionFilter < Queries::Filters::Base
  self.model = Action

  def human_name
    Action.human_attribute_name(name)
  end
end
