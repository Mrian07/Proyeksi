#-- encoding: UTF-8

class Queries::Principals::Filters::NameFilter < Queries::Principals::Filters::PrincipalFilter
  include Queries::Filters::Shared::UserNameFilter
end
