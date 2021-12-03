

class Services::CreateWatcher
  def initialize(work_package, user)
    @work_package = work_package
    @user = user

    @watcher = Watcher.new(user: user, watchable: work_package)
  end

  def run(send_notifications: true, success: ->(*) {}, failure: ->(*) {})
    if @work_package.watcher_users.include?(@user)
      success.(created: false)
    elsif @watcher.valid?
      @work_package.watchers << @watcher
      success.(created: true)
      ProyeksiApp::Notifications.send(ProyeksiApp::Events::WATCHER_ADDED,
                                      watcher: @watcher,
                                      watcher_setter: User.current,
                                      send_notifications: send_notifications)
    else
      failure.(@watcher)
    end
  end
end
