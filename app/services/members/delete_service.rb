

class Members::DeleteService < ::BaseServices::Delete
  include Members::Concerns::CleanedUp

  protected

  def after_perform(service_call)
    super(service_call).tap do |call|
      member = call.result

      cleanup_for_group(member)
      send_notification(member)
    end
  end

  def send_notification(member)
    ::ProyeksiApp::Notifications.send(ProyeksiApp::Events::MEMBER_DESTROYED,
                                      member: member)
  end

  def cleanup_for_group(member)
    return unless member.principal.is_a?(Group)

    Groups::CleanupInheritedRolesService
      .new(member.principal, current_user: user, contract_class: EmptyContract)
      .call
  end
end
