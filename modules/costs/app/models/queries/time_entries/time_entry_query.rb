

class Queries::TimeEntries::TimeEntryQuery < Queries::BaseQuery
  def self.model
    TimeEntry
  end

  def default_scope
    TimeEntry.visible(User.current)
  end
end
