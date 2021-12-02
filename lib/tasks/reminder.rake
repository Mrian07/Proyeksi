#-- encoding: UTF-8



desc <<~END_DESC
    Send reminders about issues due in the next days.
  #{'  '}
    Available options:
      * days     => number of days to remind about (defaults to 7)
      * type     => id of type (defaults to all type)
      * project  => id or identifier of project (defaults to all projects)
      * users    => comma separated list of user ids who should be reminded
  #{'  '}
    Example:
      rake redmine:send_reminders days=7 users="1,23, 56" RAILS_ENV="production"
END_DESC

namespace :redmine do
  task send_reminders: :environment do
    reminder = ProyeksiApp::Reminders::DueIssuesReminder.new(days: ENV['days'], project_id: ENV['project'],
                                                             type_id: ENV['type'], user_ids: ENV['users'].to_s.split(',').map(&:to_i))
    reminder.remind_users
  end
end
