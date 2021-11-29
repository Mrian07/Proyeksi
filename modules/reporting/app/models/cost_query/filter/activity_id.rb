

class CostQuery::Filter::ActivityId < Report::Filter::Base
  def self.label
    TimeEntry.human_attribute_name(:activity)
  end

  def self.available_values(*)
    TimeEntryActivity.order(Arel.sql('name')).pluck(:name, :id)
  end
end
