#-- encoding: UTF-8

class Queries::Members::Filters::StatusFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::UserStatusFilter

  def joins
    :principal
  end
end
