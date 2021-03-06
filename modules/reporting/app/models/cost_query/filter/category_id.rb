

class CostQuery::Filter::CategoryId < Report::Filter::Base
  use :null_operators
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:category)
  end

  def self.available_values(*)
    Category
      .where(project_id: Project.visible.map(&:id))
      .map { |c| ["#{c.project.name} - #{c.name} ", c.id] }
      .sort_by { |a| a.first.to_s + a.second.to_s }
  end
end
