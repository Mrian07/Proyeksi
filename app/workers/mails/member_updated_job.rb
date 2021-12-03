class Mails::MemberUpdatedJob < Mails::MemberJob
  private

  alias_method :send_for_project_user, :send_updated_project

  def send_for_group_user(current_user, member, _group, message)
    send_updated_project(current_user, member, message)
  end
end
