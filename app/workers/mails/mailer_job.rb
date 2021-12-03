#-- encoding: UTF-8

##
# This job gets called when internally using
#
# ```
# UserMailer.some_mail("some param").deliver_later
# ```
#
# because we want to have the sending of the email run in an `ApplicationJob`
# as opposed to using `ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper`.
# We want it to run in an `ApplicationJob` because of the shared setup required
# such as reloading the mailer configuration and resetting the request store.
class Mails::MailerJob < ApplicationJob
  queue_as { ActionMailer::Base.deliver_later_queue_name }

  # Retry mailing jobs three times with exponential backoff
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  # If exception is handled in mail handler
  # retry_on will be ignored
  rescue_from StandardError, with: :handle_exception_with_mailer_class

  def perform(mailer, mail_method, delivery, args:)
    mailer.constantize.public_send(mail_method, *args).send(delivery)
  end

  private

  # "Deserialize" the mailer class name by hand in case another argument
  # (like a Global ID reference) raised DeserializationError.
  def mailer_class
    if mailer = Array(@serialized_arguments).first || Array(arguments).first
      mailer.constantize
    end
  end

  def handle_exception_with_mailer_class(exception)
    if klass = mailer_class
      klass.handle_exception exception
    else
      raise exception
    end
  end
end
