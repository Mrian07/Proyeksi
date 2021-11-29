

class CostQuery::Filter::PriorityId < Report::Filter::Base
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:priority)
  end

  def self.available_values(*)
    IssuePriority.order(Arel.sql('position DESC')).pluck(:name, :id)
  end
end
