#-- encoding: UTF-8

class Queries::PlaceholderUsers::Filters::AnyNameAttributeFilter < Queries::PlaceholderUsers::Filters::NameFilter
  include Queries::Filters::Shared::AnyUserNameAttributeFilter
end
