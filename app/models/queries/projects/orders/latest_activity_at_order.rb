#-- encoding: UTF-8

class Queries::Projects::Orders::LatestActivityAtOrder < Queries::Orders::Base
  self.model = Project

  def self.key
    :latest_activity_at
  end

  private

  def order
    with_raise_on_invalid do
      model.order(Arel.sql("activity.latest_activity_at").send(direction))
    end
  end
end
