#-- encoding: UTF-8

class Queries::Members::Filters::NameFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::UserNameFilter

  def joins
    :principal
  end
end
