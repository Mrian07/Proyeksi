#-- encoding: UTF-8

# Sends digest mails. Digest mails contain the combined information of multiple updates to
# resources.
# Currently, this is limited to work packages

class DigestMailer < ApplicationMailer
  include ProyeksiApp::StaticRouting::UrlHelpers
  include ProyeksiApp::TextFormatting
  include Redmine::I18n
  include MailDigestHelper

  helper :mail_digest,
         :mail_notification

  MAX_SHOWN_WORK_PACKAGES = 15

  class << self
    def generate_message_id(_, user)
      hash = "proyeksiapp.digest-#{user.id}-#{Time.current.strftime('%Y%m%d%H%M%S')}"
      host = Setting.mail_from.to_s.gsub(%r{\A.*@}, '')
      host = "#{::Socket.gethostname}.proyeksiapp" if host.empty?
      "#{hash}@#{host}"
    end
  end

  def work_packages(recipient_id, notification_ids)
    recipient = User.find(recipient_id)

    open_project_headers User: recipient.name
    message_id 'digest', recipient

    @user = recipient
    @notification_ids = notification_ids
    @aggregated_notifications = load_notifications(notification_ids)
                                  .sort_by(&:created_at)
                                  .reverse
                                  .group_by(&:resource)

    @mentioned_count = @aggregated_notifications
                         .values
                         .flatten
                         .map(&:reason)
                         .compact
                         .count("mentioned")

    return if @aggregated_notifications.empty?

    with_locale_for(recipient) do
      subject = "#{Setting.app_title} - #{digest_summary_text(notification_ids.size, @mentioned_count)}"

      mail to: recipient.mail,
           subject: subject
    end
  end

  protected

  def load_notifications(notification_ids)
    Notification
      .where(id: notification_ids)
      .includes(:project, :resource, journal: %i[data attachable_journals customizable_journals])
      .reject { |notification| notification.resource.nil? || notification.project.nil? || notification.journal.nil? }
  end
end
