#-- encoding: UTF-8



# Returns a scope of users watching the instance that should be notified via whatever channel upon updates to the instance.
# The users need to have the necessary permissions to see the instance as defined by the watchable_permission.
# Additionally, the users need to have their mail notification setting set to watched: true.
module Users::Scopes
  module WatcherRecipients
    extend ActiveSupport::Concern

    class_methods do
      def watcher_recipients(model)
        model
          .possible_watcher_users
          .where(id: NotificationSetting
                       .applicable(model.project)
                       .where(watched: true, user_id: model.watcher_users)
                       .select(:user_id))
      end
    end
  end
end
