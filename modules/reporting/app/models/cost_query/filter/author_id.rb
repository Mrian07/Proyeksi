

class CostQuery::Filter::AuthorId < CostQuery::Filter::UserId
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:author)
  end

  def self.available_values(*)
    CostQuery::Filter::UserId.available_values
  end
end
