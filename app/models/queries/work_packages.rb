#-- encoding: UTF-8

module Queries::WorkPackages
  filters_module = Queries::WorkPackages::Filter
  register = Queries::Register

  register.filter Query, filters_module::AssignedToFilter
  register.filter Query, filters_module::AssigneeOrGroupFilter
  register.filter Query, filters_module::AttachmentContentFilter
  register.filter Query, filters_module::AttachmentFileNameFilter
  register.filter Query, filters_module::AuthorFilter
  register.filter Query, filters_module::CategoryFilter
  register.filter Query, filters_module::CreatedAtFilter
  register.filter Query, filters_module::CustomFieldFilter
  register.filter Query, filters_module::DoneRatioFilter
  register.filter Query, filters_module::DueDateFilter
  register.filter Query, filters_module::EstimatedHoursFilter
  register.filter Query, filters_module::GroupFilter
  register.filter Query, filters_module::IdFilter
  register.filter Query, filters_module::PriorityFilter
  register.filter Query, filters_module::ProjectFilter
  register.filter Query, filters_module::ResponsibleFilter
  register.filter Query, filters_module::RoleFilter
  register.filter Query, filters_module::StartDateFilter
  register.filter Query, filters_module::StatusFilter
  register.filter Query, filters_module::SubjectFilter
  register.filter Query, filters_module::SubprojectFilter
  register.filter Query, filters_module::OnlySubprojectFilter
  register.filter Query, filters_module::TypeFilter
  register.filter Query, filters_module::UpdatedAtFilter
  register.filter Query, filters_module::VersionFilter
  register.filter Query, filters_module::WatcherFilter
  register.filter Query, filters_module::DatesIntervalFilter
  register.filter Query, filters_module::ParentFilter
  register.filter Query, filters_module::PrecedesFilter
  register.filter Query, filters_module::FollowsFilter
  register.filter Query, filters_module::RelatesFilter
  register.filter Query, filters_module::DuplicatesFilter
  register.filter Query, filters_module::DuplicatedFilter
  register.filter Query, filters_module::BlocksFilter
  register.filter Query, filters_module::BlockedFilter
  register.filter Query, filters_module::PartofFilter
  register.filter Query, filters_module::IncludesFilter
  register.filter Query, filters_module::RequiresFilter
  register.filter Query, filters_module::RequiredFilter
  register.filter Query, filters_module::DescriptionFilter
  register.filter Query, filters_module::SearchFilter
  register.filter Query, filters_module::CommentFilter
  register.filter Query, filters_module::SubjectOrIdFilter
  register.filter Query, filters_module::ManualSortFilter
  register.filter Query, filters_module::RelatableFilter
  register.filter Query, filters_module::MilestoneFilter
  register.filter Query, filters_module::TypeaheadFilter

  columns_module = Queries::WorkPackages::Columns

  register.column Query, columns_module::PropertyColumn
  register.column Query, columns_module::CustomFieldColumn
  register.column Query, columns_module::RelationToTypeColumn
  register.column Query, columns_module::RelationOfTypeColumn
end
