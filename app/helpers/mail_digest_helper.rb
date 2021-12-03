#-- encoding: UTF-8

module MailDigestHelper
  def digest_summary_text(notification_count, mentioned_count)
    mentioned = mentioned_count > 1 ? 'plural' : 'singular'
    notifications = notification_count > 1 ? 'plural' : 'singular'

    summary = I18n.t(:"mail.digests.unread_notification_#{notifications}",
                     number_unread: notification_count).to_s

    unless mentioned_count === 0
      summary << " #{I18n.t(:"mail.digests.including_mention_#{mentioned}",
                            number_mentioned: mentioned_count)}"
    end

    summary
  end

  def digest_notification_timestamp_text(notification, html: true)
    journal = notification.journal
    user = html ? link_to_user(journal.user, only_path: false) : journal.user.name

    timestamp_text(user, journal)
  end

  def digest_additional_author_text(notifications)
    number_of_additional_authors = number_of_authors(notifications) - 1

    if notifications.length > 1 && number_of_additional_authors > 0
      amount = number_of_additional_authors === 1 ? 'one' : 'other'
      I18n.t(:"js.notifications.center.and_more_users.#{amount}", count: number_of_additional_authors)
    end
  end

  private

  def timestamp_text(user, journal)
    value = journal.initial? ? "created" : "updated"
    sanitize(
      I18n.t(:"mail.work_packages.#{value}_at",
             user: user,
             timestamp: journal.created_at.strftime(
               "#{I18n.t(:'date.formats.default')}, #{I18n.t(:'time.formats.time')}"
             ))
    )
  end

  def number_of_authors(notifications)
    notifications.group_by { |n| n[:actor_id] }.count
  end
end
