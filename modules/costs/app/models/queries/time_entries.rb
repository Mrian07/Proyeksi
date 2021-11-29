#-- encoding: UTF-8



module Queries::TimeEntries
  query = Queries::TimeEntries::TimeEntryQuery

  Queries::Register.filter query, Queries::TimeEntries::Filters::UserFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::WorkPackageFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::ProjectFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::SpentOnFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::CreatedAtFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::UpdatedAtFilter
  Queries::Register.filter query, Queries::TimeEntries::Filters::ActivityFilter

  Queries::Register.order query, Queries::TimeEntries::Orders::DefaultOrder
end
