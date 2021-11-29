#-- encoding: UTF-8



class Queries::TimeEntries::Orders::DefaultOrder < Queries::Orders::Base
  self.model = TimeEntry

  def self.key
    /\A(id|hours|spent_on|created_at|updated_at)\z/
  end
end
