#-- encoding: UTF-8

class Queries::Projects::Orders::NameOrder < Queries::Orders::Base
  self.model = Project

  def self.key
    :name
  end

  def scope
    super.select('projects.*', 'lower(projects.name)')
  end

  def order
    with_raise_on_invalid do
      model.order(Arel.sql("lower(projects.name)").send(direction))
    end
  end
end
