#-- encoding: UTF-8



class Notifications::GroupMemberAlteredJob < ApplicationJob
  queue_with_priority :notification

  def perform(members_ids, message)
    each_member(members_ids) do |member|
      OpenProject::Notifications.send(event_type(member),
                                      member: member,
                                      message: message)
    end
  end

  private

  def event_type(member)
    if matching_timestamps?(member)
      OpenProject::Events::MEMBER_CREATED
    else
      OpenProject::Events::MEMBER_UPDATED
    end
  end

  def matching_timestamps?(member)
    member.updated_at == member.created_at
  end

  def each_member(members_ids, &block)
    Member
      .where(id: members_ids)
      .each(&block)
  end
end
