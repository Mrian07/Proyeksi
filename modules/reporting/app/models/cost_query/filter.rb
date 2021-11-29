

require "set"

class CostQuery::Filter < Report::Filter
  def self.all
    @all ||= super + Set[
      CostQuery::Filter::ActivityId,
      CostQuery::Filter::AssignedToId,
      CostQuery::Filter::AuthorId,
      CostQuery::Filter::BudgetId,
      CostQuery::Filter::CategoryId,
      CostQuery::Filter::CostTypeId,
      CostQuery::Filter::CreatedOn,
      CostQuery::Filter::DueDate,
      CostQuery::Filter::VersionId,
      CostQuery::Filter::WorkPackageId,
      CostQuery::Filter::OverriddenCosts,
      CostQuery::Filter::PriorityId,
      CostQuery::Filter::ProjectId,
      CostQuery::Filter::ResponsibleId,
      CostQuery::Filter::SpentOn,
      CostQuery::Filter::StartDate,
      CostQuery::Filter::StatusId,
      CostQuery::Filter::Subject,
      CostQuery::Filter::TypeId,
      CostQuery::Filter::UpdatedOn,
      CostQuery::Filter::UserId,
      CostQuery::Filter::PermissionFilter,
      *CostQuery::Filter::CustomFieldEntries.all
    ]
  end
end
