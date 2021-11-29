

class CostQuery::Filter::BudgetId < Report::Filter::Base
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    Budget.model_name.human
  end

  def self.available_values(*)
    Budget
      .visible(User.current)
      .includes(:project)
      .pluck(:'projects.name', :subject, :id)
      .map { |a| ["#{a[0]} - #{a[1]} ", a[2]] }
      .sort_by { |a| a.first.downcase }
  end
end
