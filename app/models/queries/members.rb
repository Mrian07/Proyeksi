#-- encoding: UTF-8



module Queries::Members
  query = Queries::Members::MemberQuery
  filter_ns = Queries::Members::Filters

  Queries::Register.filter query, filter_ns::NameFilter
  Queries::Register.filter query, filter_ns::AnyNameAttributeFilter
  Queries::Register.filter query, filter_ns::ProjectFilter
  Queries::Register.filter query, filter_ns::StatusFilter
  Queries::Register.filter query, filter_ns::BlockedFilter
  Queries::Register.filter query, filter_ns::GroupFilter
  Queries::Register.filter query, filter_ns::RoleFilter
  Queries::Register.filter query, filter_ns::PrincipalFilter
  Queries::Register.filter query, filter_ns::CreatedAtFilter
  Queries::Register.filter query, filter_ns::UpdatedAtFilter

  order_ns = Queries::Members::Orders

  Queries::Register.order query, order_ns::DefaultOrder
  Queries::Register.order query, order_ns::NameOrder
  Queries::Register.order query, order_ns::EmailOrder
  Queries::Register.order query, order_ns::StatusOrder
end
