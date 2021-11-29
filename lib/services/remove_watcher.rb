

class Services::RemoveWatcher
  def initialize(work_package, user)
    @work_package = work_package
    @user = user
  end

  def run(success: -> {}, failure: -> {})
    watcher = @work_package.watchers.find_by_user_id(@user.id)

    if watcher.present?
      @work_package.watcher_users.delete(@user)
      success.call
      OpenProject::Notifications.send(OpenProject::Events::WATCHER_REMOVED,
                                      watcher: watcher,
                                      watcher_remover: User.current)
    else
      failure.call
    end
  end
end
