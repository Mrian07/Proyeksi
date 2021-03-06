#-- encoding: UTF-8

module Queries::Roles
  register = ::Queries::Register
  filters = ::Queries::Roles::Filters
  query = ::Queries::Roles::RoleQuery

  register.filter query, filters::GrantableFilter
  register.filter query, filters::UnitFilter
end
