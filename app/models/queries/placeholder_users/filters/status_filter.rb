#-- encoding: UTF-8

class Queries::PlaceholderUsers::Filters::StatusFilter < Queries::PlaceholderUsers::Filters::PlaceholderUserFilter
  include Queries::Filters::Shared::UserStatusFilter
end
