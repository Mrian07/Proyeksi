#-- encoding: UTF-8

class Queries::PlaceholderUsers::Filters::NameFilter < Queries::PlaceholderUsers::Filters::PlaceholderUserFilter
  include Queries::Filters::Shared::UserNameFilter
end
