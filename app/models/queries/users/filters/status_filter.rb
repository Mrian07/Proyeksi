#-- encoding: UTF-8



class Queries::Users::Filters::StatusFilter < Queries::Users::Filters::UserFilter
  include Queries::Filters::Shared::UserStatusFilter
end
