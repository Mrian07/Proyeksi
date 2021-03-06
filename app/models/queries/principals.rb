#-- encoding: UTF-8

module Queries::Principals
  register = ::Queries::Register
  filters = ::Queries::Principals::Filters
  query = ::Queries::Principals::PrincipalQuery
  orders = Queries::Principals::Orders

  register.filter query, filters::TypeFilter
  register.filter query, filters::MemberFilter
  register.filter query, filters::StatusFilter
  register.filter query, filters::NameFilter
  register.filter query, filters::AnyNameAttributeFilter
  register.filter query, filters::IdFilter

  register.order query, orders::NameOrder
end
