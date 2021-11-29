#-- encoding: UTF-8



class Queries::Projects::Orders::ProjectStatusOrder < Queries::Orders::Base
  self.model = Project

  def self.key
    :project_status
  end

  def left_outer_joins
    :status
  end

  private

  def order
    with_raise_on_invalid do
      model.order(Arel.sql("project_statuses.code").send(direction))
    end
  end
end
