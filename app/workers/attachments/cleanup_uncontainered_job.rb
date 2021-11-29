#-- encoding: UTF-8



class Attachments::CleanupUncontaineredJob < ::Cron::CronJob
  queue_with_priority :low

  # runs at 10:03 pm
  self.cron_expression = '03 22 * * *'

  def perform
    Attachment
      .where(container: nil)
      .where(too_old)
      .destroy_all

    Attachment
      .pending_direct_upload
      .where(too_old)
      .destroy_all # prepared direct uploads that never finished
  end

  private

  def too_old
    attachment_table = Attachment.arel_table

    attachment_table[:created_at]
      .lteq(Time.now - OpenProject::Configuration.attachments_grace_period.minutes)
      .to_sql
  end
end
