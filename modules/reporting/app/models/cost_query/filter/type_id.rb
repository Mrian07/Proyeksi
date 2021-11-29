

class CostQuery::Filter::TypeId < Report::Filter::Base
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:type)
  end

  def self.available_values(*)
    Type.order(Arel.sql('name')).pluck(:name, :id)
  end
end
