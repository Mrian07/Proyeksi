#-- encoding: UTF-8



# Sends mails for updates to memberships. There can be three cases we have to cover:
# * user is added to a project
# * existing project membership is altered
# * global roles are altered
#
# There is no creation of a global membership as far as the user is concerned. Hence, all
# global cases can be covered by one method.
#
# The mailer does not fan out in case a group is provided. The individual members of a group
# need to be mailed to individually.

class MemberMailer < ApplicationMailer
  include ProyeksiApp::StaticRouting::UrlHelpers
  include ProyeksiApp::TextFormatting

  def added_project(current_user, member, message)
    alter_project(current_user,
                  member,
                  in_member_locale(member) { I18n.t(:'mail_member_added_project.subject', project: member.project.name) },
                  message)
  end

  def updated_project(current_user, member, message)
    alter_project(current_user,
                  member,
                  in_member_locale(member) { I18n.t(:'mail_member_updated_project.subject', project: member.project.name) },
                  message)
  end

  def updated_global(current_user, member, message)
    send_mail(current_user,
              member,
              in_member_locale(member) { I18n.t(:'mail_member_updated_global.subject') },
              message)
  end

  private

  def alter_project(current_user, member, subject, message)
    send_mail(current_user,
              member,
              subject,
              message) do
      open_project_headers Project: member.project.identifier

      @project = member.project
    end
  end

  def send_mail(current_user, member, subject, message)
    in_member_locale(member) do
      User.execute_as(current_user) do
        message_id member, current_user

        @roles = member.roles
        @principal = member.principal
        @message = message

        yield if block_given?

        mail to: member.principal.mail,
             subject: subject
      end
    end
  end

  def in_member_locale(member, &block)
    raise ArgumentError unless member.principal.is_a?(User)

    with_locale_for(member.principal, &block)
  end
end
