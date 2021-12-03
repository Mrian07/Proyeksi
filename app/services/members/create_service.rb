#-- encoding: UTF-8

class Members::CreateService < ::BaseServices::Create
  around_call :post_process

  def post_process
    service_call = yield

    return unless service_call.success?

    member = service_call.result

    add_group_memberships(member)
    send_notification(member)
  end

  protected

  def send_notification(member)
    ProyeksiApp::Notifications.send(ProyeksiApp::Events::MEMBER_CREATED,
                                    member: member,
                                    message: params[:notification_message],
                                    send_notifications: params.fetch(:send_notifications, true))
  end

  def add_group_memberships(member)
    return unless member.principal.is_a?(Group)

    Groups::AddUsersService
      .new(member.principal, current_user: user, contract_class: EmptyContract)
      .call(ids: member.principal.user_ids, send_notifications: false)
  end

  def set_attributes_params(params)
    super.except(:notification_message, :send_notifications)
  end
end
