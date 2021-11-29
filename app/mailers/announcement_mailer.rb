

# Sends mails for announcements.
# For now, it cannot handle sending events on any Announcement model but is rather focused
# on handing very simple mails where only the recipient, subject and body is provided.

class AnnouncementMailer < ApplicationMailer
  include OpenProject::StaticRouting::UrlHelpers
  include OpenProject::TextFormatting
  helper :mail_notification

  def announce(user, subject:, body:, body_header: nil, body_subheader: nil)
    with_locale_for(user) do
      localized_subject = localized(subject)

      mail to: user.mail,
           subject: localized_subject do |format|
        locals = {
          body: localized(body),
          user: user,
          header_summary: localized_subject,
          body_header: localized(body_header),
          body_subheader: localized(body_subheader)
        }

        format.html { render locals: locals }
        format.text { render locals: locals }
      end
    end
  end

  private

  def localized(input)
    if input.is_a?(Symbol)
      I18n.t(input)
    else
      input
    end
  end
end
