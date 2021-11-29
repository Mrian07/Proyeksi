

class CostQuery::GroupBy::BudgetId < Report::GroupBy::Base
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    Budget.model_name.human
  end
end
