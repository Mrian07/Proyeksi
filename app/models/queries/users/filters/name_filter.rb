#-- encoding: UTF-8



class Queries::Users::Filters::NameFilter < Queries::Users::Filters::UserFilter
  include Queries::Filters::Shared::UserNameFilter
end
