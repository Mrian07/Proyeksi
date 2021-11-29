#-- encoding: UTF-8



class Roles::UpdateService < ::BaseServices::Update
  include Roles::NotifyMixin

  private

  def after_safe
    notify_changed_roles(:updated, model)
  end
end
