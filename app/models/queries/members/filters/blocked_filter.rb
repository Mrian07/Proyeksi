#-- encoding: UTF-8

class Queries::Members::Filters::BlockedFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::UserBlockedFilter

  def joins
    :principal
  end
end
