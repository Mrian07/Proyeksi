#-- encoding: UTF-8

module Queries
  module Relations
    register = ::Queries::Register
    filters = ::Queries::Relations::Filters
    query = ::Queries::Relations::RelationQuery

    register.filter query, filters::IdFilter
    register.filter query, filters::FromFilter
    register.filter query, filters::ToFilter
    register.filter query, filters::InvolvedFilter
    register.filter query, filters::TypeFilter

    register.order query, ::Queries::Relations::Orders::DefaultOrder
  end
end
