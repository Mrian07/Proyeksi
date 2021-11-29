#-- encoding: UTF-8



class Mails::DeliverJob < ApplicationJob
  queue_with_priority :notification

  def perform(recipient_id)
    self.recipient_id = recipient_id

    return if abort?

    deliver_mail
  end

  private

  attr_accessor :recipient_id

  def abort?
    # nothing to do if recipient was deleted in the meantime
    recipient.nil?
  end

  def deliver_mail
    mail = User.execute_as(recipient) { build_mail }

    mail&.deliver_now
  end

  # To be implemented by subclasses.
  # Returns a Mail::Message, or nil if no message should be sent.
  def render_mail
    raise NotImplementedError, 'SubclassResponsibility'
  end

  def build_mail
    render_mail
  rescue NotImplementedError
    # Notify subclass of the need to implement
    raise
  rescue StandardError => e
    Rails.logger.error "#{self.class.name}: Unexpected error rendering a mail: #{e}"
    # not raising, to avoid re-schedule of DelayedJob; don't expect render errors to fix themselves
    # by retrying
    nil
  end

  def recipient
    @recipient ||= if recipient_id.is_a?(User)
                     recipient_id
                   else
                     User.find_by(id: recipient_id)
                   end
  end
end
