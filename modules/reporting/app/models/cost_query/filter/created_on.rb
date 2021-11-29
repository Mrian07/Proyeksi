

class CostQuery::Filter::CreatedOn < Report::Filter::Base
  db_field 'entries.created_at'
  use :time_operators

  def self.label
    WorkPackage.human_attribute_name(:created_at)
  end
end
