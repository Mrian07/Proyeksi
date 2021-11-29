

class Mails::MemberJob < ApplicationJob
  queue_with_priority :notification

  def perform(current_user:,
              member:,
              message: nil)
    if member.project.nil?
      send_updated_global(current_user, member, message)
    elsif member.principal.is_a?(Group)
      every_group_user_member(member) do |user_member|
        send_for_group_user(current_user, user_member, member, message)
      end
    elsif member.principal.is_a?(User)
      send_for_project_user(current_user, member, message)
    end
  end

  private

  def send_for_group_user(_current_user, _member, _group, _message)
    raise NotImplementedError, "subclass responsibility"
  end

  def send_for_project_user(_current_user, _member, _message)
    raise NotImplementedError, "subclass responsibility"
  end

  def send_updated_global(current_user, member, member_message)
    return if sending_disabled?(:updated, current_user, member.user_id, member_message)

    MemberMailer
      .updated_global(current_user, member, member_message)
      .deliver_now
  end

  def send_added_project(current_user, member, member_message)
    return if sending_disabled?(:added, current_user, member.user_id, member_message)

    MemberMailer
      .added_project(current_user, member, member_message)
      .deliver_now
  end

  def send_updated_project(current_user, member, member_message)
    return if sending_disabled?(:updated, current_user, member.user_id, member_message)

    MemberMailer
      .updated_project(current_user, member, member_message)
      .deliver_now
  end

  def every_group_user_member(member, &block)
    Member
      .of(member.project)
      .where(principal: member.principal.users)
      .includes(:project, :principal, :roles, :member_roles)
      .each(&block)
  end

  def sending_disabled?(setting, current_user, user_id, message)
    # Never self notify
    return true if current_user.id == user_id
    # In case we have an invitation message, always send a mail
    return false if message.present?

    NotificationSetting
      .where(project_id: nil, user_id: user_id)
      .exists?("membership_#{setting}" => false)
  end
end
