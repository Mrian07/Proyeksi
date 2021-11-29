#-- encoding: UTF-8



class Queries::TimeEntries::Filters::TimeEntryFilter < Queries::Filters::Base
  self.model = TimeEntry

  def human_name
    TimeEntry.human_attribute_name(name)
  end
end
