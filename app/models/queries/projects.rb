#-- encoding: UTF-8



module Queries::Projects
  filters = ::Queries::Projects::Filters
  orders = ::Queries::Projects::Orders
  query = ::Queries::Projects::ProjectQuery

  ::Queries::Register.register do
    filter query, filters::AncestorFilter
    filter query, filters::TypeFilter
    filter query, filters::ActiveFilter
    filter query, filters::TemplatedFilter
    filter query, filters::PublicFilter
    filter query, filters::NameAndIdentifierFilter
    filter query, filters::CustomFieldFilter
    filter query, filters::CreatedAtFilter
    filter query, filters::LatestActivityAtFilter
    filter query, filters::PrincipalFilter
    filter query, filters::ParentFilter
    filter query, filters::IdFilter
    filter query, filters::ProjectStatusFilter
    filter query, filters::UserActionFilter
    filter query, filters::VisibleFilter

    order query, orders::DefaultOrder
    order query, orders::LatestActivityAtOrder
    order query, orders::RequiredDiskSpaceOrder
    order query, orders::CustomFieldOrder
    order query, orders::ProjectStatusOrder
    order query, orders::NameOrder
  end
end
