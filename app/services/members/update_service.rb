#-- encoding: UTF-8



class Members::UpdateService < ::BaseServices::Update
  include Members::Concerns::CleanedUp

  around_call :post_process

  private

  def post_process
    service_call = yield

    return unless service_call.success?

    member = service_call.result

    if member.principal.is_a?(Group)
      update_group_roles(member)
    else
      send_notification(member)
    end
  end

  def send_notification(member)
    ProyeksiApp::Notifications.send(ProyeksiApp::Events::MEMBER_UPDATED,
                                    member: member,
                                    message: notification_message)
  end

  def update_group_roles(member)
    Groups::UpdateRolesService
      .new(member.principal, current_user: user, contract_class: EmptyContract)
      .call(member: member, send_notifications: true, message: notification_message)
  end

  def set_attributes_params(params)
    super.except(:notification_message)
  end

  def notification_message
    params[:notification_message]
  end
end
