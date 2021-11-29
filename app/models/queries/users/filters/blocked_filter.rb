#-- encoding: UTF-8



class Queries::Users::Filters::BlockedFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::UserBlockedFilter
end
