#-- encoding: UTF-8

class Queries::Members::Filters::AnyNameAttributeFilter < Queries::Members::Filters::NameFilter
  include Queries::Filters::Shared::AnyUserNameAttributeFilter
end
