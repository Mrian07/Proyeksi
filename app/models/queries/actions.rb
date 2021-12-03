module Queries::Actions
  query = Queries::Actions::ActionQuery
  filter_ns = Queries::Actions::Filters

  Queries::Register.filter query, filter_ns::IdFilter
end
