#-- encoding: UTF-8



class Queries::TimeEntries::Filters::CreatedAtFilter < Queries::TimeEntries::Filters::TimeEntryFilter
  def type
    :datetime_past
  end
end
