#-- encoding: UTF-8



module TimeEntries::Scopes
  module OfUserAndDay
    extend ActiveSupport::Concern

    class_methods do
      def of_user_and_day(user, date, excluding: nil)
        scope = TimeEntry
                  .where(spent_on: date,
                         user: user)

        if excluding
          scope = scope.where.not(id: excluding.id)
        end

        scope
      end
    end
  end
end
