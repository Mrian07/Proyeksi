#-- encoding: UTF-8



module Roles::NotifyMixin
  private

  def notify_changed_roles(action, changed_role)
    ProyeksiApp::Notifications.send(:roles_changed, action: action, role: changed_role)
  end
end
