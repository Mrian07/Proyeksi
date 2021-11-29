

class CostQuery::Filter::ResponsibleId < CostQuery::Filter::UserId
  use :null_operators
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:responsible)
  end

  def self.available_values(*)
    CostQuery::Filter::UserId.available_values
  end
end
