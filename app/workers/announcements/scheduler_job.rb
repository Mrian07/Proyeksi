module Announcements
  class SchedulerJob < ::ApplicationJob
    queue_with_priority :low

    def perform(**announcement)
      User.active.find_each do |user|
        AnnouncementMailer
          .announce(user, **announcement)
          .deliver_later
      end
    end
  end
end
