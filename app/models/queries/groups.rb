#-- encoding: UTF-8

module Queries::Groups
  order_ns = Queries::Members::Orders
  query = Queries::Members::MemberQuery

  Queries::Register.order query, order_ns::DefaultOrder
end
