#-- encoding: UTF-8

class Queries::Users::Filters::AnyNameAttributeFilter < Queries::Users::Filters::NameFilter
  include Queries::Filters::Shared::AnyUserNameAttributeFilter
end
