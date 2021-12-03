#-- encoding: UTF-8

class Queries::Principals::Filters::AnyNameAttributeFilter < Queries::Principals::Filters::NameFilter
  include Queries::Filters::Shared::AnyUserNameAttributeFilter
end
