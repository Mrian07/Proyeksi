#-- encoding: UTF-8



class Queries::TimeEntries::Filters::SpentOnFilter < Queries::TimeEntries::Filters::TimeEntryFilter
  def type
    :date
  end
end
