#-- encoding: UTF-8

module Queries::Capabilities
  query = Queries::Capabilities::CapabilityQuery
  filter_ns = Queries::Capabilities::Filters

  Queries::Register.filter query, filter_ns::IdFilter
  Queries::Register.filter query, filter_ns::PrincipalIdFilter
  Queries::Register.filter query, filter_ns::ContextFilter
  Queries::Register.filter query, filter_ns::ActionFilter

  order_ns = Queries::Capabilities::Orders

  Queries::Register.order query, order_ns::IdOrder
end
