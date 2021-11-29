#-- encoding: UTF-8



module Queries::PlaceholderUsers
  Queries::Register.filter Queries::PlaceholderUsers::PlaceholderUserQuery,
                           Queries::PlaceholderUsers::Filters::NameFilter

  Queries::Register.filter Queries::PlaceholderUsers::PlaceholderUserQuery,
                           Queries::PlaceholderUsers::Filters::AnyNameAttributeFilter

  Queries::Register.filter Queries::PlaceholderUsers::PlaceholderUserQuery,
                           Queries::PlaceholderUsers::Filters::GroupFilter

  Queries::Register.filter Queries::PlaceholderUsers::PlaceholderUserQuery,
                           Queries::PlaceholderUsers::Filters::StatusFilter

  Queries::Register.order Queries::PlaceholderUsers::PlaceholderUserQuery,
                          Queries::PlaceholderUsers::Orders::DefaultOrder

  Queries::Register.order Queries::PlaceholderUsers::PlaceholderUserQuery,
                          Queries::PlaceholderUsers::Orders::NameOrder

  Queries::Register.order Queries::PlaceholderUsers::PlaceholderUserQuery,
                          Queries::PlaceholderUsers::Orders::GroupOrder
end
