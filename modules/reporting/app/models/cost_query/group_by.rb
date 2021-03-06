

require "set"

class CostQuery::GroupBy < Report::GroupBy
  def self.all
    @all ||= super + Set[
      CostQuery::GroupBy::ActivityId,
      CostQuery::GroupBy::BudgetId,
      CostQuery::GroupBy::CostTypeId,
      CostQuery::GroupBy::VersionId,
      CostQuery::GroupBy::WorkPackageId,
      CostQuery::GroupBy::PriorityId,
      CostQuery::GroupBy::ProjectId,
      CostQuery::GroupBy::SpentOn,
      CostQuery::GroupBy::SingletonValue,
      CostQuery::GroupBy::Tmonth,
      CostQuery::GroupBy::TypeId,
      CostQuery::GroupBy::Tyear,
      CostQuery::GroupBy::UserId,
      CostQuery::GroupBy::Week,
      CostQuery::GroupBy::AuthorId,
      CostQuery::GroupBy::AssignedToId,
      CostQuery::GroupBy::CategoryId,
      CostQuery::GroupBy::StatusId,
      *CostQuery::GroupBy::CustomFieldEntries.all
    ]
  end
end
